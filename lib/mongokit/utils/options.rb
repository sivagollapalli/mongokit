module Mongokit
  class Options

    CRITERIAS = [:only, :except, :add, :replace]

    def initialize(options = {})
      @options = options
    end

    def all
      @options
    end

    def put(name, values)
      @options[name] = values
    end

    def get(name, field = nil)
      field ? @options[name][field] : @options[name]
    end

    class << self
      def only(fields, options)
        fields = fields.select{ |f, _| options[:only].include?(f) } if options[:only]
        fields
      end

      def except(fields, options)
        fields = fields.reject{ |f, _| options[:except].include?(f) } if options[:except]
        fields
      end

      def add(fields, options)
        return unless options[:add]

        fields.is_a?(Hash) ? fields.merge(options[:add]) : fields.concat(options[:add])
      end

      def replace(fields, options)
        options[:replace].each { |f| fields[f] = fields.delete(f) } if options[:replace]
        fields
      end

      def process(fields, options, criterias = nil)
        criterias = options.keys unless criterias

        criterias.each do |c|
          fields = send(c, fields, options) if CRITERIAS.include?(c)
        end

        fields
      end
    end

    # Used for common options store.
    module Store
      def mk_options
        @mk_options ||= Options.new
      end
    end
  end
end
