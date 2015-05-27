require 'mongoid'

module Mongokit

  MODULE_NAMES = %w(
    AutoIncrement
    SecureToken
    Address
    CsvTransformer
    ModelHelpers
  ).inject({}) do |result, module_name|
    result[module_name.underscore.to_sym] = module_name
    result
  end

  MODULE_NAMES.each do |module_name, const_name|
    autoload const_name, "mongokit/#{module_name}"
  end

  autoload :Options, 'mongokit/utils/options'

  MongokitError = Class.new(StandardError)

  def self.modules
    MODULE_NAMES.values
  end

  def self.config(options = {})
    options[:load] = Array(options[:load])

    options[:load].each do |module_name|
      require "mongokit/#{module_name}"
    end
  end
end

require 'mongokit/version'
require 'mongokit/extensions/mongoid_document'
require 'mongokit/find_in_batch'
