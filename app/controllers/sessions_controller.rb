require 'net/https'
require 'net/http'
require "uri"
require 'json'
require "base64"

class SessionsController < ApplicationController
  
  def create 
    code = params[:code]
    @token = get_token(code)

    #API call to /me to get student/teacher id
    uri = URI('https://api.clever.com/me')

    http = Net::HTTP.new(uri.host, uri.port)
    http.set_debug_output($stdout) 
    http.use_ssl = true
    http.ssl_version = :SSLv3
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field 'Authorization', "Bearer #{@token['access_token']}"

    @response = http.request(request)
    @body = JSON.parse(@response.body)
    @id = @body['data']['id']
    @name = @body['data']['name']['first']

    #create/store user
    user = User.find_by_uid(@id) || User.create_with_omniauth(@id, @name)
    session[:user_id] = user.id
    
    if @body['type'] == 'student'
      #API Call to student sections
      student_sections

    elsif @body['type'] == 'teacher'
      #API Call to teacher sections
      teacher_sections
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end


private

  def get_token(code)
    uri = URI('https://clever.com/oauth/token')

    http = Net::HTTP.new(uri.host, uri.port)
    http.set_debug_output($stdout) 
    http.use_ssl = true
    http.ssl_version = :SSLv3
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.start

    request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
    request.basic_auth('1da85a8592e00bdb1240', 'ca5cadf1b610e4c37cb838279c9a3bdb3c8bf1cc')
    request.body = {'code' => code, 'grant_type' => 'authorization_code', 'redirect_uri' => 'http://localhost:3000/oauth'}.to_json
    
    @response = http.request(request)
    @body = JSON.parse(@response.body)

  end

  def student_sections
      uri = URI("https://api.clever.com/v1.1/students/#{@id}/sections")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field 'Authorization', 'Bearer 2d24a8c82a8071721e1b0affdc3936362c5b41f1'

      response = http.request(request)
      @body = JSON.parse(response.body)
      @sections = @body['data']
  end

  def teacher_sections
      uri = URI("https://api.clever.com/v1.1/teachers/#{@id}/sections")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field 'Authorization', 'Bearer 2d24a8c82a8071721e1b0affdc3936362c5b41f1'

      response = http.request(request)
      @body = JSON.parse(response.body)
      @sections = @body['data']
  end


end
