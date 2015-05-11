require 'mongokit/csv_transformer/csv_io'

module Mongokit
  module CsvTransformer
    extend ActiveSupport::Concern

    module ClassMethods
      CsvTransformerError = Class.new(StandardError)

      def csv_import_mapping(name, fields, options = {},  &block)
        if respond_to?("from_#{name}_csv")
          raise CsvTransformerError, "#{name} import mapper is already defined."
        end

        self.class.instance_eval do
          define_method "from_#{name}_csv" do |file|
            options[:columns] = fields
            csv_import(file, options, &block)
          end
        end
      end

      def csv_export_mapping(name, fields, options = {},  &block)
        if respond_to?("to_#{name}_csv")
          raise CsvTransformerError, "#{name} export mapper is already defined."
        end

        self.class.instance_eval do
          define_method "to_#{name}_csv" do |file, criteria = nil|
            options[:columns] = fields
            criteria = self.all if criteria.nil?
            csv_export(file, criteria, options, &block)
          end
        end
      end

      def _csv_columns(options = nil)
        columns = fields.collect do |f, o|
          if o.class == Mongoid::Fields::Standard && o.type != BSON::ObjectId
            o.name
          end
        end

        columns.compact!
        options ? Options.process(columns, options) : columns
      end

      def csv_export(file, criteria, options = {}, &block)
        columns = _csv_columns(options)
        io = CsvIO.new(:write, file, columns, options)

        criteria.each do |record|
          row = io.to_row(record, block)
          io << row if row
        end
      end

      def csv_import(file, options = {}, &block)
        io = CsvIO.new(:read, file, options[:columns] || _csv_columns, options)

        io.each do |row|
          attrs = io.to_attrs(row, block)
          create(attrs) if attrs
        end
      end
    end
  end
end
