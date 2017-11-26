Given(/^a client does not know how to format path info to call the service$/) do
  # do-nothing method
end

Then(/^the service returns information about how to format path info$/) do
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
  expect(@response.body).to eq(help)
end