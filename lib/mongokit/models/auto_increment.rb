module Mongokit
  module Models
    class AutoIncrement
      include Mongoid::Document
      include Mongoid::Timestamps

      store_in(collection: 'custom_auto_increments')

      field :counter_model_name, type: String
      field :counter, type: Integer, default: 0

      index({counter_model_name: 1})
    end
  end
end
