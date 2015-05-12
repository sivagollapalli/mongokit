module Mongokit
  module ModelHelpers
    extend ActiveSupport::Concern

    module ClassMethods
      def boolean_methods(field_name, values, options = {})
        values = values.zip(values).to_h if values.is_a?(Array)

        values.each do |f, v|
          method_name = [
            options[:prefix],
            f,
            options[:postfix],
          ].compact.join('_')

          define_method "#{method_name}?" do
            v == self[field_name]
          end
        end
      end

      def multi_fields(*args)
        type = args.pop
        fields = args

        unless type.is_a?(Class)
          fields << type
          type = String
        end

        fields.each do |f|
          if f.is_a?(Hash)
            f, default_value = f.flatten
          end

          field f, type: type, default: default_value
        end
      end

      def field_with_validation(field_name, options = {})
        field field_name, {
          type: options.delete(:type) || String,
          default: options.delete(:default)
        }

        if options.any?
          validates field_name, options
        end
      end
    end
  end
end
