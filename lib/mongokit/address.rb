module Mongokit
  module Address
    extend ActiveSupport::Concern

    module ClassMethods
      ADDRESS_FIELDS = {
        address_1:   String,
        address_2:   String,
        street:      String,
        city:        String,
        state:       String,
        postal_code: String,
        country:     String,
        latitude:    Float,
        longitude:   Float
      }.freeze

      def has_address(options = {})
        fields = ADDRESS_FIELDS.dup

        if options[:add]
          if options[:add].is_a?(Array)
            options[:add] = options[:add].inject({}){|r, f| r[f] = String; r}
          end
          fields.merge!(options[:add])
        end

        if options[:except]
          fields.reject!{|f, _| options[:except].include?(f)}
        end

        if options[:replace]
          options[:replace].each { |f| fields[f] = fields.delete(f) }
        end

        fields.each do |name, type|
          field name, type: type
        end

        @_addrs_fields_ = fields.keys
        @_full_addrs_fields_ = fields.reject{|f, _| f == :latitude || f == :longitude }.keys
      end

      def address_fields
        @_addrs_fields_
      end

      def full_address(obj, options = nil)
        fields = @_full_addrs_fields_

        if options
          fields = if options[:only]
                     options[:only]
                   elsif options[:except]
                     @_full_addrs_fields_ - options[:except]
                   end
        end

        fields.map{|f| obj[f]}.join(', ')
      end
    end

    def full_address(options = nil)
      self.class.full_address(self, options)
    end
  end
end
