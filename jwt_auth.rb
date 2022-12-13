require 'sinatra'
require 'pry'
require "base64"
require 'json'
require 'securerandom'

AVAILABLE_TOKENS = []

def generate_token
  SecureRandom.hex.tap { |token| AVAILABLE_TOKENS.push(token) }
end

def current_bearer_token
  # delete "Bearer ""
  http_auth_data[7..]
end

def http_auth_data
  request.env["HTTP_AUTHORIZATION"]
end

before do
  content_type :json
end

get '/' do
  if http_auth_data.nil?
    generate_token
  elsif AVAILABLE_TOKENS.include?(current_bearer_token)
    'Success! :)'
  else
    'Failed :('
  end
end

