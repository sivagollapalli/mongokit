require 'csv'

module Mongokit
  module CsvExporter
    extend ActiveSupport::Concern

    module ClassMethods
      def csv_exporter(fields = nil)
      end

      def to_csv(file, criteria = nil)
      end
    end
  end
end
