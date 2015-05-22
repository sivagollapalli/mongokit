require_relative 'common'

class ZipCode
  include Mongoid::Document

  mongokit :csv_transformer

  field :name, type: String
  field :zip_code, type: Integer
  field :region, type: String
  field :district, type: String
  field :state, type: String

  csv_import_mapping :zipcode_arr, [:name, :zip_code] do |row, attrs|
    attrs[:zip_code] = attrs[:zip_code].to_i
  end

  csv_import_mapping :zipcode, {name: 0, zip_code: 1, region: 5, district: 8, state: 9}, headers: true do |row, attrs|
    attrs[:zip_code] = attrs[:zip_code].to_i
    attrs[:state].downcase!
  end

  csv_export_mapping :zipcode, [:name, :zip_code, :region], headers: true do |row, record|
    row[:zip_code] = "I-#{row[:zip_code]}"
  end

end

ZipCode.destroy_all
ZipCode.from_zipcode_csv('data/zip.csv')
ZipCode.to_zipcode_csv('data/out_zip.csv')
ZipCode.all.each do |z|
  puts z.inspect
end

# ZipCode.to_zipcode_csv('1.csv', ZipCode.where(zip_code: 504293))
