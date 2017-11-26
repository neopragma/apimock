Feature: Handling bad requests

Scenario: Client provides invalid Accept header value
  When a client invokes the service with method 'GET', path info '/help', accept header 'batman'
  Then the service returns '400 Bad Request'
  And the error message is 'Accept or Content-type header must be, *json, *xml, or text/plain. Received: '

Scenario: Client specifies unknown route
  When a client invokes the service with method 'GET', path info '/nosuchroute', accept header 'json'
  Then the service returns '404 Not Found'