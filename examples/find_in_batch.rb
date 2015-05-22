require 'bundler/setup'
require 'mongoid'
require 'mongokit'
require 'csv'

Mongoid.load!("#{File.expand_path(File.dirname(__FILE__))}/mongoid.yml", :production)

Mongokit.config(load: :find_in_batch)

class ZipCode
  include Mongoid::Document

  field :name, type: String
  field :zip_code, type: Integer
  field :region, type: String
  field :district, type: String
  field :state, type: String
end

ZipCode.in_batches(batch_size: 2) do |arr|
  puts arr.inspect
end
