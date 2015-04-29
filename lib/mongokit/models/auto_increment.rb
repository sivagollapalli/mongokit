module Mongokit
  module Models
    class AutoIncrement
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in(collection: 'custom_auto_increments')

      field :counter_model_name, type: String
      field :counter, type: Integer, default: 0

      index({counter_model_name: 1})

      def self.counter(counter_model_name, options, next_options)
        element = Models::AutoIncrement.find_or_create_by(counter_model_name: counter_model_name)
        element.counter += 1 if next_options[:next]

        Mongokit::Formater.new.format(element.counter, options)
      end
    end
  end
end
