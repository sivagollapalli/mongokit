require 'mongokit/auto_increment/counter'
require 'mongokit/auto_increment/formater'
require 'mongokit/models/auto_increment'

module Mongokit
  module AutoIncrement

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
      #     auto_increment :order_no, type: String
      #   end
      #
      def auto_increment(attribute, _options = {})
        field(attribute, type: _options[:type] || String)

        options = {
          pattern: "%Y%m#####",
          number_symbol: "#",
          attribute: attribute,
          start:  0
        }

        options.merge!(_options)

        @_auto_incr_options_ = options

        define_method("reserve_#{options[:attribute]}!") do
          self[attribute] = Mongokit::Counter.next(self, options)
        end

        # Signing before_create
        before_create do |record|
          record[attribute] = Mongokit::Counter.next(self, options)
        end
      end

      def auto_incrementer_current
        Mongokit::Models::AutoIncrement.counter(self.collection_name, @_auto_incr_options_, { next: false })
      end

      def auto_incrementer_next
        Mongokit::Models::AutoIncrement.counter(self.collection_name, @_auto_incr_options_, { next: true })
      end
    end
  end
end
