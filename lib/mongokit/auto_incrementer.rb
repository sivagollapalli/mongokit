require 'mongokit/auto_incrementer/counter'
require 'mongokit/auto_incrementer/formater'
require 'mongokit/models/auto_increment'

module Mongokit
  module AutoIncrementer

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      #
      # == Example
      #   class Order
      #     include Mongoid::Document
      #     include Mongoid::AutoIncrement
      #
      #     field :order_no, type: String
      #     auto_increment :order_no
      #   end
      #
      def auto_increment(column, _options = {})
        options = {
          pattern: "%Y%m#####",
          number_symbol: "#",
          column: column,
          start:  0
        }

        options.merge!(_options)

        # Defining custom method
        send :define_method, "reserve_#{options[:column]}!".to_sym do
          self[column] = Mongokit::Counter.next(self, options)
        end

        # Signing before_create
        before_create do |record|
          unless record[column].present?
            record[column] = Mongokit::Counter.next(self, options)
          end
        end
      end
    end
  end
end
