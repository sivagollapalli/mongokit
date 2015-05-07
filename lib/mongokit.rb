require 'mongoid'

require 'mongokit/version'
require 'mongokit/mongoid_ext'

module Mongokit
  MODULE_NAMES = %w(
    AutoIncrement
    SecureToken
  ).inject({}){ |r, m| r[m.underscore.to_sym] = m; r }

  MODULE_NAMES.each do |module_name, const_name|
    autoload const_name, "mongokit/#{module_name}"
  end
end
