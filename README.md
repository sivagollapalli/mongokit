# Mongokit

Mongoid helpers like export/import csv, autoincrement, find in batch, address helper, securetoken field, boolean methods

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongokit', '0.0.1'

gem 'mongokit', github: 'jiren/mongokit' # master branch
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongokit 

## Usage

1. Auto incrementing field with pattern and without patterns.

```
 auto_increment :order_no, pattern: '%Y%m#####’   # this can be use for invoice generation.
 auto_increment :rank
```

2. secure_token to generate api keys, season keys etc.

```
has_secure_token :auth_token, token_length: 20  # token length is optional
```

Output: 
```
user.auth_token # => “77TMHrHJFvFDwodq8w7Ev2m7"
```

3. find_in_batch 

Mongodb using cursor to iterate collections if collection is too large then it is  giving cursor timeout error. In this case this is helpful.

```ruby
Order.in_batches(batch_size: 100, start: 50)  do |orders|
  ....
end

# with criteria
Order.where(:created_at.gt => Time.now.yesterday).in_batches do |orders|
   ...
 end
```
4. Csv transformer. Import / Export csv by defining mapping like this in models.

  * Import

```ruby
csv_import_mapping :address, [:name, :zip_code], headers: true do |row, attrs|
  attrs[:zip_code] = attrs[:zip_code].to_i  # Processing block
end
```

Use:

```
 Address.from_address_csv('address.csv')
```
  * Export

```ruby 
csv_export_mapping :address, [:zip_code, :name, :region] do |row, record|
  row[:zip_code] = "IN-#{row[:zip_code]}"
end
```

Use:
```  
 Address.to_address_csv('address.csv’)
```

5. Model helpers: mult fields definition, field with validations and boolean methods.
 
- Define multiple fields using single line.

  i.e 
  
```
multi_fields :city, { venue: 'Mumbai' }, :country
multi_fields :start_time, :end_time, DateTime
```

-  Define field with validations.

   i.e 

```
field_with_validation(:team_type, inclusion: { in: %w(t20 odi test) })
```

- Boolean methods

```
field :format, type: String # defined field

boolean_methods(:match_type, %w(t20 odi test), { postfix: 'match' } )
```

Above line is included in model then this will going to define methods on object like

```
record.t20_match?   
record.odi_match?
```
Internal methods declaration for `match_type` field

```ruby
def t20_match?
   match_type == “t20"
end
```

Check examples folder

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mongokit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
