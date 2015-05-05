require 'securerandom'

module Mongokit
  module SecureToken
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Example using has_secure_token
      #
      #   # Schema: User(auth_token:string)
      #   class User
      #     include Mongoid::Document
      #     include Mongokit::SecureToken
      #
      #     has_secure_token :auth_token
      #     # has_secure_token :auth_token, token_length: 20
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

        @_st_options_ = (options || {}).tap do |o|
          o[:attribute] = attribute
          o[:random_string] = (('0'..'9').to_a  + ('A'..'Z').to_a + ('a'..'z').to_a - ['0', 'O', 'I', 'l']).sample(4).join
          o[:token_length] ||= 16
        end

        before_create do
          self[attribute] = self.class.generate_unique_secure_token
        end

        define_method("regenerate_#{attribute}!") do
          update_attributes(attribute => self.class.generate_unique_secure_token)
        end

        self.class.instance_eval do
          define_method("find_by_#{attribute}") do |token|
            where(attribute => token).first
          end
        end
      end

      def generate_unique_secure_token
        loop do
          token = SecureRandom.base64(@_st_options_[:token_length]).tr('0+/=', @_st_options_[:random_string])
          break token unless where(@_st_options_[:attribute] => token).exists?
        end
      end
    end
  end
end
