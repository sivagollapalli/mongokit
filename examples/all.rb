require_relative 'common'

def run_all
  [
    'address',
    'auto_increment',
    'csv_transformer',
    'find_in_batch',
    'secure_token'
  ].each do |m|
    puts ''
    puts "***** #{m.upcase} *****"
    require_relative m
  end
end

run_all
