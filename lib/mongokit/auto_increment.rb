require 'mongokit/auto_increment/counter'
require 'mongokit/auto_increment/formater'
require 'mongokit/models/auto_increment_counter'

module Mongokit
  module AutoIncrement
    extend ActiveSupport::Concern

    module ClassMethods
      #
      # == Example
      #   class Order
      #     include Mongoid::Document
      #     include Mongoid::AutoIncrement
      #
      #     auto_increment :order_count,
      #     auto_increment :order_no, pattern: "%Y%m#####"  # Default no symbol is #
      #   end
      #
      def auto_increment(attribute, _options = {})
        options = {
          number_symbol: '#',
          start:  0,
          step: 1
        }

        options.merge!(_options)
        options[:attribute] = attribute
        options[:model] = self
        options[:type] ||= Integer

        if options[:pattern]
          options[:time_format] = Mongokit::Counter.to_time_format(options[:pattern])
          options[:type] = String
        end

        field(attribute, type: options[:type])

        # create new record in counter collection
        Models::AutoIncrementCounter.find_or_create_with_seed(options)

        before_create do |doc|
          doc[attribute] = Mongokit::Counter.next(options)
        end

        define_method("reserve_#{options[:attribute]}!") do
          self[attribute] = Mongokit::Counter.next(options)
        end

        define_method("current_#{attribute}_counter") do
          Models::AutoIncrementCounter.current_counter(options)
        end
      end
    end
  end
end
