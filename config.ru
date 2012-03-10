require 'bundler'
Bundler.require

require './application'

map '/' do
  run Application
end
