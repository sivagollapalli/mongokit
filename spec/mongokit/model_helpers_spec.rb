require 'spec_helper'

describe Mongokit::ModelHelpers do

  module MongokitTest
    class Game
      include Mongoid::Document

      mongokit :model_helpers

      field :format, type: String
      field :team_category, type: Integer
    end
  end

  let(:model) { MongokitTest::Game }

  describe "#multi_fields" do
    it 'define fields with one field has default vanue' do
      model.multi_fields :city, { venue: 'Mumbai' }, :country

      expect(model.fields.keys).to include('city', 'venue', 'country')

      record = model.new
      expect(record.venue).to eq 'Mumbai'
    end

    it 'define fields with types' do
      model.multi_fields :start_time, :end_time, DateTime

      expect(model.fields.keys).to include('start_time', 'end_time')

      expect(model.fields['start_time'].options[:type]).to eq DateTime
      expect(model.fields['end_time'].options[:type]).to eq DateTime
    end
  end

  describe '#field_with_validation' do
    it 'define field with validation' do
      model.field_with_validation(:team_type, inclusion: { in: %w(t20 odi test) })

      expect(model.fields['team_type']).to be_present

      record = model.new
      expect(record.valid?).to be false
      expect(record.errors[:team_type]).to include('is not included in the list')
    end
  end

  describe '#boolean methods' do
    it 'define boolean methods for given values as array with postfix' do
      model.boolean_methods(:format, %w(t20 odi test), { postfix: 'match' } )
      record = model.new

      [:t20_match?, :odi_match?, :test_match?].each do |m|
        expect(record).to respond_to(m)
      end

      record.format = 't20'
      expect(record.t20_match?).to be true
      expect(record.test_match?).to be false
      expect(record.odi_match?).to be false
    end

    it 'define boolean methods for given values as hash' do
      model.boolean_methods(:team_category, { club: 0, national: 1 } )
      record = model.new

      [:club?, :national?].each do |m|
        expect(record).to respond_to(m)
      end

      record.team_category = 0
      expect(record.club?).to be true
      expect(record.national?).to be false
    end
  end

end
