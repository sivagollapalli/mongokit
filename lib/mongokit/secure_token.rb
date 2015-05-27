require 'securerandom'

module Mongokit
  module SecureToken
    extend ActiveSupport::Concern

    module ClassMethods
      # == Example
      #
      #   class User
      #     include Mongoid::Document
      #
      #     mongokit :secure_token
      #
      #     has_secure_token :auth_token
      #     # has_secure_token :auth_token, token_length: 20
      #
      #     # multiple tokens
      #     # has_secure_token :public_key
      #     # has_secure_token :private_key, token_length: 20
      #   end
      #
      #   user = User.new
      #   user.save
      #   user.auth_token # => "77TMHrHJFvFDwodq8w7Ev2m7"
      #   user.regenerate_auth_token! # => true
      #
      def has_secure_token(attribute, options = {})
        field(attribute, type: String)
        index({ attribute => 1 }, { unique: true })

        @_st_options_ ||= {}
        @_st_options_[attribute] =  (options || {}).tap do |o|
          o[:random_string] = (('0'..'9').to_a  + ('A'..'Z').to_a + ('a'..'z').to_a - ['0', 'O', 'I', 'l']).sample(4).join
          o[:token_length] ||= 16
        end

        before_create do |doc|
          doc[attribute] = doc.class.generate_unique_secure_token(attribute)
        end

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def regenerate_#{attribute}!
            update_attributes(#{attribute}: self.class.generate_unique_secure_token(:#{attribute}))
          end
        RUBY

        self.class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def find_by_#{attribute}(token)
            where(#{attribute}: token).first
          end
        RUBY
      end

      def generate_unique_secure_token(attribute)
        options = @_st_options_[attribute]

        loop do
          token = SecureRandom.base64(options[:token_length]).tr('0+/=', options[:random_string])
          break token unless where(attribute => token).exists?
        end
      end
    end
  end
end
