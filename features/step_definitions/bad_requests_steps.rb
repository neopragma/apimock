# bad_requests_steps.rb

Then("the service returns {string}") do |error_message|
  expect(@error_message).to eql("#{error_message}")
end

Then("the error message is {string}") do |error_response|
  expect(@error_response_body).to eql("#{error_response}")
end