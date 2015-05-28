require 'bundler/setup'
require 'pp'
require 'mongoid'
require 'mongokit'

Mongoid.load!("#{File.expand_path(File.dirname(__FILE__))}/mongoid.yml", :production)


def run_all
  [
    'address',
    'auto_increment',
    'csv_transformer',
    'find_in_batch',
    'secure_token'
  ].each do |m|
    puts "***** #{m.upcase} *****"
    require_relative m
    nil
  end
end

run_all if ARGV.first == 'all'
