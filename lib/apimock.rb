# apimock
require_relative "./apimock/version"
require 'sinatra'
require 'json'
require 'xmlsimple'
require 'cgi'

set :show_exceptions, :after_handler
set :raise_errors, true

GlobalState = {}
before do
  @content_type = 'text/plain'
  if (request.accept != nil)
  	@content_type = request.accept[0]
    @content_type = 'json' if (request.accept.select{ |i| i.end_with?('json') }.length) > 0
    @content_type = 'xml' if (request.accept.select{ |i| i.end_with?('xml') }.length) > 0
  elsif (request.content_type != nil)
  	@content_type = request.content_type
    @content_type = 'json' if request.content_type.end_with? 'json'
    @content_type = 'xml' if request.content_type.end_with? 'xml'
  end 

  request.body.rewind
  request_body = request.body.read
  @content_type = @content_type.to_s

  case @content_type
  when 'json'
    @request_payload = JSON.parse request_body unless request_body.length == 0
  when 'xml'
    @request_payload = XmlSimple.xml_in request_body unless request_body.length == 0
  when 'text/plain' 
  	@request_payload = request_body unless request_body.length == 0
  else 
  	error_message = "Accept or Content-type header must be, *json, *xml, or text/plain. Received: #{@content_type}"
    $stderr.puts error_message
    halt 400, error_message
    @request_payload = nil
  end
end

# Return the mocked response body and response code defined for GET + path_info after '/mock'
get '/apimock/:api_version/mock/*' do 
  data_key = create_data_key_from_uri

puts "data_key: #{data_key}"

  response_body = prepare_output GlobalState[:data][data_key]['responseBody'] unless GlobalState[:data][data_key]['responseBody'] == nil
  response_body.delete!('\\') unless response_body == nil

puts "data: #{GlobalState[:data]}"
puts "data[data_key]: #{GlobalState[:data][data_key]}"
puts "data[data_key][:responseCode]: #{GlobalState[:data][data_key]['responseCode']}"
  response_code = GlobalState[:data][data_key]['responseCode'].to_i

puts "response_body: #{response_body}"
puts "response_code: #{response_code}"


  [ response_code, {}, response_body ]
end 



# Return usage help for apimock
get '/apimock/help' do 
  help = "apimock: current version is 1.0.0\n"
  help += "GET /apimock/help => return this help text\n"
  help += "GET /apimock/versions => returns list of api versions supported\n"
  help += "GET /apimock/v1.0.0/data => returns the currently-defined mock data\n"
  help += "PUT /apimock/v1.0.0/data => initializes mock data using the JSON payload passed\n"
  help += "POST /apimock/v1.0.0/data => adds or updates the specified mock data\n"
  help += "DELETE /apimock/v1.0.0/data => removes the specified mock data\n"
  help += "DELETE /apimock/v1.0.0/data/all => clears all the mock data\n"
  help += "GET /apimock/v1.0.0/mock/uri => responds with the response code and response body specified for GET/uri\n"
  help += "PUT /apimock/v1.0.0/mock/uri => responds with the response code and response body specified for PUT/uri\n"
  help += "POST /apimock/v1.0.0/mock/uri => responds with the response code and response body specified for POST/uri\n"
  help += "DELETE /apimock/v1.0.0/mock/uri => responds with the response code and response body specified for DELETE/uri\n"
  [ 200, help ]
end 

# Return the api versions supported by this server
get '/apimock/versions' do 
  prepare_output({ :versions => [ 'v1.0.0' ] })
end

# Return the mock data that is currently defined
get '/apimock/:api_version/data' do 
  prepare_output({ :data => GlobalState[:data] })
end

# Add or change the mock data for the given request method and request uri
post '/apimock/:api_version/data' do  
  add_or_replace_data   
  200
end

# Initialize the mock data with the values passed
put '/apimock/:api_version/data' do
  clear_data
  add_data
  200
end

# Remove all the mock data
delete '/apimock/:api_version/data/all' do 
  clear_data 
  200 
end

# Remove the mock data for the given request method and request uri
delete '/apimock/:api_version/data' do 
  GlobalState[:data] = GlobalState[:data].tap { |d| d.delete(create_hash_key) }
  200
end

# use the request method and the remaining text in the request uri following '/mock'
# to form the key to look up the response body and response code for this mock.
def create_data_key_from_uri 
  ix = (request.path_info.index '/mock/') + ('/mock'.length)
  "#{request.request_method}|#{request.path_info[ix..-1]}"
end

# Prepare output in XML or JSON format for /apimock calls (not user mock calls)
def prepare_output hash
  case @content_type 
  when 'json'
    content_type :json 
    hash.to_json
  when 'xml' 
    content_type :xml 
    xml_text = XmlSimple.xml_out hash
    xml_text = CGI.unescapeHTML(xml_text)
  else 
    content_type :text 
    "Unsupported content type: #{@content_type}"
  end 
end 

def add_or_replace_data
  clear_data unless GlobalState[:data]
  add_data
  200
end

def add_data 
  GlobalState[:data][create_hash_key] = @request_payload
end

def clear_data
  GlobalState[:data] = {}
end

def create_hash_key 
  "#{@request_payload['method']}|#{@request_payload['uri']}"
end 
