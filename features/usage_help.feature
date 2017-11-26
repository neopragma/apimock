Feature: Getting help for formulating queries

Scenario: Client wants to know how to use the service
  Given a client does not know how to format path info to call the service
  When a client invokes the service with method 'GET', path info '/help', accept header 'text/plain'
  Then the service returns information about how to format path info