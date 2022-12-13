require 'sinatra'
require 'pry'
require "base64"
require 'json'
require 'securerandom'

AVAILABLE_TOKENS = []

def current_cookie_token
  request.cookies["token"]
end

def generate_token
  new_token = SecureRandom.hex
  AVAILABLE_TOKENS.push(new_token)
  response.set_cookie("token", new_token)
end

before do
  content_type :json
end

get '/' do
  generate_token unless current_cookie_token

  if AVAILABLE_TOKENS.include?(current_cookie_token)
    'Success! :)'
  else
    'Failed :('
  end
end

