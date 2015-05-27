module Mongokit
  module Address
    extend ActiveSupport::Concern

    #
    # == Example
    #   class User
    #     include Mongoid::Document
    #
    #     mongokit :address
    #     has_address
    #
    #     # OR
    #     # has_address(except: [:latitude, :longitude])
    #     # has_address(replace: {address_1: :street_1, address_2: :street_2})
    #   end
    #
    #   user = User.create({
    #     address_1:   'Studio 103',
    #     address_2:   'The Business Centre',
    #     street:      '61 Wellfield Road',
    #     city:        'Roath',
    #     state:       'Cardiff',
    #     postal_code: 'CF24 3DG',
    #     country:     'England'
    #   })
    #
    #   user.full_address # Studio 103, The Business Centre, 61 Wellfield Road, Roath, Cardiff, CF24 3DG, England
    #
    module ClassMethods
      include Options::Store

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
          else
            fields.merge!(options[:add])
          end
        end

        fields = Options.process(fields, options)

        fields.each do |name, type|
          field name, type: type
        end

        mk_options.tap do |o|
          o.put(:address_fields, fields.keys)
          o.put(:full_address_fields, fields.reject{|f, _| f == :latitude || f == :longitude }.keys)
        end
      end

      def address_fields
        mk_options.get(:address_fields)
      end

      def full_address(obj, options = nil)
        fields = mk_options.get(:full_address_fields)

        if options
          if options[:only]
            fields = options[:only]
          elsif options[:except]
            fields = fields - options[:except]
          end
        end

        fields.map{|f| obj[f]}.compact.join(', ')
      end
    end

    def full_address(options = nil)
      self.class.full_address(self, options)
    end
  end
end
