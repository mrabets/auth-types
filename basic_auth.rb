require 'sinatra'
require 'pry'
require "base64"
require 'json'

def admin_login_password
  "admin:admin"
end

def current_auth_data
  # delete 'Basic '
  Base64.decode64(request.env.fetch("HTTP_AUTHORIZATION")[6..])
end

before do
  content_type :json
end


get '/' do
  if current_auth_data == admin_login_password
    'Success! :)'
  else
    'Failed :('
  end
end

