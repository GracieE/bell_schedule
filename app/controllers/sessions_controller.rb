require 'net/https'
require 'net/http'
require "uri"
require 'json'
require "base64"

class SessionsController < ApplicationController
  
  def create 
    code = params[:code]
    getToken(code)
    # user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    # session[:user_id] = user.id
    #redirect_to root_url, :notice => "Signed in!
  end


private

  def getToken(code)
    uri = URI('https://clever.com/oauth/token')

    http = Net::HTTP.new(uri.host, uri.port)
    http.set_debug_output($stdout) 
    http.use_ssl = true
    http.ssl_version = :SSLv3
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.start
    client = Base64.encode64('1da85a8592e00bdb1240:ca5cadf1b610e4c37cb838279c9a3bdb3c8bf1cc').chop

    request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
    request.body = {'code' => code, 'grant_type' => 'authorization_code', 'redirect_uri' => 'https://localhost:3000/oauth'}.to_json
    #request.set_form_data({'code' => code, 'grant_type' => 'authorization_code', 'redirect_uri' => 'http://localhost:3000/oauth'})
    
    request.add_field 'Authorization', 'Basic ' + client
    @response = http.request(request)
    #@body = JSON.parse(@response.body)

  end
end
