module Mongokit
  module Counter
    module_function

    def next(options)
      record = Models::AutoIncrementCounter.where({
        counter_model_name: options[:model].collection_name,
        counter_field: options[:attribute]
      }).find_and_modify({ '$inc' => { counter: options[:step] }}, new: true)

      return record.counter if options[:pattern].nil?

      #if outdated?(record, options[:time_format])
      #  record.set(counter: options[:start] + options[:step])
      #end

      Formater.new.format(record.counter, options)
    end

    def outdated?(record, time_format)
      Time.now.strftime(time_format).to_i > record.updated_at.strftime(time_format).to_i
    end

    def to_time_format(pattern)
      event = String.new

      event += '%Y' if pattern.include? '%y' or pattern.include? '%Y'
      event += '%m' if pattern.include? '%m'
      event += '%H' if pattern.include? '%H'
      event += '%M' if pattern.include? '%M'
      event += '%d' if pattern.include? '%d'
      event
    end
  end
end
