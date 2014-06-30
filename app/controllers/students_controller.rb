require 'net/https'
require "uri"
require 'json'

class StudentsController < ApplicationController
  def index
    uri = URI('https://api.clever.com/v1.1/sections')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.ssl_version = :SSLv3
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field 'Authorization', 'Bearer 2d24a8c82a8071721e1b0affdc3936362c5b41f1'

    @response = http.request(request)
    @body = JSON.parse(@response.body)
    @sections = @body['data']
  end

  def show
    @param = params[:id]
    uri = URI("https://api.clever.com/v1.1/sections/#{@param}/students")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.ssl_version = :SSLv3
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field 'Authorization', 'Bearer 2d24a8c82a8071721e1b0affdc3936362c5b41f1'

    @response = http.request(request)
    @body = JSON.parse(@response.body)
    @students = @body['data']
  end

end
