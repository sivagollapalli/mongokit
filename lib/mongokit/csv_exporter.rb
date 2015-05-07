require 'csv'

module Mongokit
  module CSVExporter
    extend ActiveSupport::Concern

    module ClassMethods
      def csv_exporter(fields = nil)
      end

      def to_csv(file, criteria = nil)
      end
    end
  end
end
