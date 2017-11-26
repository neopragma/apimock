# apimock

## Purpose

- Mock RESTful endpoints to support automated API testing
- Meant for mocking microservices that return results as JSON or XML documents; support for mocking websites (HTML and variants) may be added in a future version

## Disclaimer

This project is at a very early stage of development. Some of the functionality described in the README is not yet in place. Anything documented up to this point is subject to change. We don't recommend using this tool for real work at this time. We plan to provide examples on the wiki. This is not started yet.

## Summary

This is a basic mocking tool for testing RESTful API calls. It is deployed as a RESTful service, and test scripts interact with it through its own API to create and destroy mocks on the fly. 

Supports

- GET
- PUT
- POST
- DELETE

for 
- application/json 
- application/xml 
- text/plain 

with or without a payload, and will return the specified HTTP response code and response body in the specified format. 


## General design goals

- Do one thing only, and do it well. 
- Avoid the feature bloat and steadily-increasing complication that seem to afflict most testing tools. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apimock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apimock

## Usage

Apimock is a Sinatra application and it runs as an HTTP server (Thin). The system that hosts the service needs a Ruby runtime environment. 

Start an apimock server as per your testing needs. For instance, you could start it on http://localhost:9292 for local testing, on a cloud service such as http://testmyfoo.herokuapp.com, or on any internal server in your organization that is accessible for supporting your test cases. 

You can start the server on the fly as part of your test script, or leave one or more instances up and running, according to your needs and preferences. Apimock's primary use case is to generate and use mocks on the fly during execution of test suites. 

Configure the test environment to point each mocked endpoint to apimock instead of to the real endpoint. How to do this depends on how the application handles configuration settings. It could be a yaml file, a Java properties file, an XML file, environment variable settings, or something else. 

In the _setup_ or _arrange_ part of each test case in your suite, or in a _before_ section (depending on how your testing tool works and how you need to set up the test cases), tell apimock what values to return for each request. Mock creation is meant to be dynamic; the tool is not designed to use predefined mocks from a database or file.

Each mocked response is identified by a combination of the request method (GET, PUT, POST, DELETE) and the portion of the request URI that follows ```/apimock/v1.0.0/mock```. 

That is, if the real invocation looks like this (using curl):

```shell 
curl -H "Content-Type: application/json" \
  -X GET http://prodserver.domain.com/customer/12345/rewardpoints
```

then the mocked endpoint could look like this (assuming the apimock server is listening on port 80 at footesting.com):

```shell 
curl -H "Content-Type: application/json" \
  -X GET http://footesting.com/apimock/v1.0.0/mock/customer/12345/rewardpoints
```

In this example, the mock is identified as ```GET|/customer/12345/rewardpoints```. 

Each URI and return value for a mock is a static string. No variable substitution is supported. This is because the tool is designed to support example-based testing, and not property-based testing or any sort of intelligent simulation. 

The tool can return a specified value for the HTTP response code and response body. At present it does not emit mocked response header values.

## Persistence of mock definitions

Apimock does not store mock definitions persistently. When the server goes down, any definitions are lost. This is by design. We want fast server startup, simple configuration, and fast execution; and we assume people will want to create the mocked values on the fly to match each test case in their automated API test suite, rather than predefining static test data to be used by many test cases. The design is intended to support a continuous delivery pipeline.

## Versioning

The project follows semantic versioning guidelines. The intent is to support backward compatibility within a major version number. That is, a call like ```http://foo/apimock/1.0.2``` will work against API version 1.2.3. It's on us to ensure the behavior is the same. You can call ```/apimock/versions``` to find out which versions are supported by the apimock server instance you are talking to.

## The API in a nutshell

These examples use curl commands to illustrate how to invoke apimock. Better documentation is under development.

Formulate calls that do the equivalent things with whatever language/tools you are using. Any tool that can generate an HTTP request will work. Be sure to set a value for either (a) Accept or (b) Content-type. Apimock will assume ```text/plain``` if no header is passed. It supports JSON, XML, and plain text. Otherwise, apimock returns HTTP response code 400.

```/apimock/[version]/data``` URIs are for creating and removing mock definitions. ```/apimock/[version]/mock``` URIs are for invoking the mocked services and retrieving the response code and body defined in the mock. 

The URIs ```/apimock/help``` and ```/apimock/versions``` don't require a version in the URI because it's likely you would not know what value to provide. All other URIs must include a version, as unspecified default behavior could make test cases fragile.

Get usage help for apimock (plain text format)

```shell
curl -H "Content-Type: application/json" \
  -X GET http://localhost:9292/apimock/help
```

Find out which version of apimock is running at the specified endpoint, and which versions of apimock it supports

```shell
curl -H "Content-Type: application/json" \
  -X GET http://localhost:9292/apimock/versions
```

Create a mock endpoint (or replace one that currently exists) that returns JSON ```{"name": "Nancy"}``` and response code 200 when invoked with GET and URI path ```/name```

```shell
curl -H "Content-Type: application/json" \
  -X POST \
  -d '{"method":"GET","uri":"/name","responseBody":"{\"name\":\"Nancy\"}", "responseCode": "200"}' \ 
  http://localhost:9292/apimock/v1.0.0/data
```

Create a mock endpoint (or replace one that currently exists) that returns XML ```<name>George</name>``` and response code 200 when invoked with GET and URI path ```/name```

```shell
curl -H "Content-Type: application/xml" \
  -X POST \
  -d '<mockdata method="GET" uri="/name" responseBody="&lt;name&gt;George&lt;/name&gt;" responseCode="200" />' \
  http://localhost:9292/apimock/v1.0.0/data
```

Retrieve the currently-defined mock data values as a JSON document

```shell
curl -H "Content-Type: application/json" \
  -X GET http://localhost:9292/apimock/v1.0.0/data
```

Retrieve the current mock data values as an XML document

```shell
curl -H "Content-Type: application/xml" \
  -X GET http://localhost:9292/apimock/v1.0.0/data
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rackup` to start a server on `localhost:9292` and `cucumber` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/neopragma/apimock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Apimock project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/neopragma/apimock/blob/master/CODE_OF_CONDUCT.md).
