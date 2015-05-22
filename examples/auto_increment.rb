require_relative 'common'

require 'mongokit/auto_increment'
Mongokit::Models::AutoIncrementCounter.delete_all

class Order
  include Mongoid::Document

  mongokit :auto_increment

  auto_increment :order_no, pattern: '%Y%m#####'
  auto_increment :rank
end

Order.destroy_all
3.times { puts Order.create.inspect }

