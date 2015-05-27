module Mongokit
  #
  # == Example
  #   Order.in_batches do |orders|
  #     orders.each do |order|
  #       puts order.items
  #     end
  #   end
  #
  #   Order.in_batches(batch_size: 100, start: 50) do |orders|
  #     ...
  #   end
  #
  #   Order.where(:created_at.gt => Time.now.yesterday).in_batches do |orders|
  #     ...
  #   end
  #
  module FindInBatch
    def in_batches(options = {})
      criteria = self
      start = options[:start]
      batch_size = options[:batch_size] || 1000

      criteria = criteria.limit(batch_size)
      records = start ? criteria.offset(start).to_a : criteria.to_a
      current_offset = start.to_i

      while records.any?
        records_size = records.size
        current_offset += records_size

        yield records

        break if records_size < batch_size

        records = criteria.offset(current_offset).to_a
      end
    end
  end
end

Mongoid::Document::ClassMethods.send :include, Mongokit::FindInBatch
Mongoid::Criteria.send :include, Mongokit::FindInBatch
