require 'rubygems'
require 'bundler/setup'

ENV['APP_DIR'] = File.expand_path('..', __FILE__)
require File.expand_path('../lib/birdie', __FILE__)
run Birdie::Application

