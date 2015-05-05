module Mongokit
  class Counter
    def self.next(object, options)
      element = Models::AutoIncrement.find_or_create_by(counter_model_name: object.class.collection_name)

      if outdated?(element, options) || element.counter == 0
        element.counter = options[:start]
      end

      element.counter += 1

      if element.changed?
        element.save!
      else
        element.touch
      end

      Formater.new.format(element.counter, options)
    end

    private

    def self.outdated?(record, options)
      Time.now.strftime(update_event(options)).to_i > record.updated_at.strftime(update_event(options)).to_i
    end

    def self.update_event(options)
      pattern = options[:pattern]
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
