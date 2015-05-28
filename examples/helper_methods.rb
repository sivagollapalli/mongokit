require_relative 'common'

class Match
  include Mongoid::Document

  mongokit :model_helpers

  field :format, type: String
  field :team_type, type: Integer, default: 0

  # multi_fields :city, :venue, :country
  # multi_fields :city, :venue, :country, String
  multi_fields :city, { venue: 'India' }, :country

  boolean_methods(:team_type, { club: 0, international: 1 } )

  boolean_methods(:format, %w(t20 odi test), { postfix: 'match' } )

  # Default type is string
  field_with_validation(:format, inclusion: { in: %w(t20 odi test) })
  # field_with_validation(:format, type: String, inclusion: { in: %w(t20 odi test) })
end

Match.destroy_all

puts "*** Boolean Methods ****"
m = Match.new(format: 't20')
puts "Method t20_match? matched : #{m.t20_match?}"
puts "Method odi_match? present : #{m.respond_to?(:odi_match?)}"
puts m.club?

puts "*** Multi Fields ***"
puts m.inspect
#pp Match.fields

puts "*** Field with validation ***"
puts Match.validators.inspect
mv = Match.new
mv.valid?
puts mv.errors.inspect
