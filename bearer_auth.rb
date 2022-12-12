require 'sinatra'
require 'pry'
require "base64"
require 'json'
require 'securerandom'

AVAILABLE_TOKENS = [
  "3ff22ec17be0575ec91cb65a02a17e70",
  "884402cf3a3f18cd8a17cb15be5f0d7b",
  "b2a82bd522780bf3a0026464521cb573"
]

def current_bearer_token
  # delete "Bearer ""
  request.env.fetch("HTTP_AUTHORIZATION")[7..]
end

before do
  content_type :json
end

get '/' do
  if AVAILABLE_TOKENS.include?(current_bearer_token)
    'Success! :)'
  else
    'Failed :('
  end
end

