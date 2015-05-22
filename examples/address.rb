require_relative 'common'

class Company
  include Mongoid::Document

  mongokit :address, :auto_increment

  has_address(except: [:latitude, :longitude])
  auto_increment :rank
end

Company.destroy_all

c =  Company.create(city: 'Mumbai')
puts c.inspect
puts c.full_address
