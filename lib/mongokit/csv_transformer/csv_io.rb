require 'csv'

module Mongokit
  class CsvIO
    attr_reader :csv, :column_mapping, :columns, :options

    def initialize(operation, file, columns, options = {})
      @options = options
      @column_mapping = build_column_mapping(columns)
      @columns = @column_mapping.keys.map(&:to_sym)

      if operation == :write
        @csv = CSV.open(file, 'wb')
        write_headers
      else
        @csv = CSV.open(file)
        @csv.readline if options[:headers]
      end
    end

    def build_column_mapping(columns)
      if columns.is_a?(Array)
        columns.zip((0..columns.length).to_a).to_h.reject{|k| k.nil? }
      else
        columns.sort_by{|_, pos| pos }.to_h
      end
    end

    def write_headers
      return if options[:headers].nil?

      if options[:headers] === true
        csv << column_mapping.map { |f, _|  f.titleize }
      else
        csv << options[:headers]
      end
    end

    def <<(row)
      csv << row
    end

    def readline
      csv.readline
    end

    def to_attrs(row, block)
      attrs = column_mapping.inject({}) do |r, (f, pos)|
        r[f] = row[pos]
        r
      end

      if block
        return false if block.call(row, attrs) == false
      end

      attrs
    end

    def to_row(record, block)
      row = CSV::Row.new(columns, columns.map {|f| record[f] })

      if block
        return false if block.call(row, record) == false
      end

      row
    end

    def each(&block)
      csv.each do |row|
        yield row
      end
    end
  end
end
