module Mongokit
  module Models
    class AutoIncrementCounter
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in(collection: 'auto_increment_counters')

      field :counter_model_name, type: String
      field :counter_field, type: String
      field :counter, type: Integer, default: 0

      index({ counter_model_name: 1, counter_field: 1 }, { unique: true })

      def self.find_or_create_with_seed(options)
        record = find_or_initialize_by({
          counter_model_name: options[:model].collection_name,
          counter_field: options[:attribute]
        })
        record.counter = options[:start] if record.new_record?
        record.save
      end

      def self.current_counter(options)
        record = Models::AutoIncrementCounter.find_by({
          counter_model_name: options[:model].collection_name,
          counter_field: options[:attribute]
        })

        return nil if record.nil?
        return record.counter if options[:pattern].nil?
        return Formater.new.format(record.counter, options)
      end
    end
  end
end
