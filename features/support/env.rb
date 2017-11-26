# env.rb for apimock
require 'json'
require 'sinatra'
require 'xmlsimple'
require 'rspec'
require 'rspec/expectations'
require 'rest-client'

ENV['RACK_ENV'] ||= 'development'
ENV['APIMOCK_URL'] ||= 'http://localhost:9292/apimock'
$BASE_URL = ENV['APIMOCK_URL']
