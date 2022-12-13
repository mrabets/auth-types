require 'sinatra'
require 'pry'
require "base64"
require 'json'
require 'securerandom'
require 'jwt'

def admin_login_password
  "admin:admin"
end

def valid_token?(jwt_token)
  decoded_token = JWT.decode current_bearer_token, nil, false
  # Array
  # [
  #   {"data"=>"admin:admin"}, # payload
  #   {"alg"=>"none"} # header
  # ]
  decoded_token[0]["data"] == admin_login_password
rescue
  false
end

def generate_token
  payload = { data: current_auth_data }
  JWT.encode payload, nil, 'none'
end

def http_auth_data
  request.env.fetch("HTTP_AUTHORIZATION")
end

def current_bearer_token
  # delete "Bearer ""
  http_auth_data[7..]
end

def current_auth_data
  # delete 'Basic '
  Base64.decode64(http_auth_data[6..])
end

def current_jwt_cookie_token
  request.cookies["jwt_token"]
end

before do
  content_type :json
end

get '/' do
  response.set_cookie("jwt_token", generate_token) unless current_jwt_cookie_token

  # Both: cookie and bearer 
  if valid_token?(current_jwt_cookie_token) && valid_token?(current_bearer_token)
    'Success! :)'
  else
    'Failed :('
  end
end

