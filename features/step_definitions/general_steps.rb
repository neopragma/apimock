# general steps

When("a client invokes the service with method {string}, path info {string}, accept header {string}") do |method, path_info, mime_type|
  begin
    @response = RestClient::Request.execute(method: :get, url: "#{$BASE_URL}#{path_info}", headers: { accept: "#{mime_type}" } )
  rescue RestClient::ExceptionWithResponse => e
    @error_response_body = e.response.body
    @error_message = e.message
  end

end
