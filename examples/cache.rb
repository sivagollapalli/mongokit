require_relative 'common'

class User
  include Mongoid::Document

  mongokit :cache

  cache(key) do |email|
    where(email: email)
  end

  def cache_list
    @cache_list ||= {}
  end

  def cache(key, &block)
    @cache_list[key] = block.call
  end

end
