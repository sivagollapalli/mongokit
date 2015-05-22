require_relative 'common'

class User
  include Mongoid::Document
  mongokit :secure_token, :auto_increment

  has_secure_token :auth_token, token_length: 20
  auto_increment :rank
end

User.destroy_all
2.times { puts User.create.inspect }

u = User.first
u.regenerate_auth_token!
puts u.inspect

puts User.find_by_auth_token(u.auth_token).inspect

