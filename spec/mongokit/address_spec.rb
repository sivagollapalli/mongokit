require 'spec_helper'

describe Mongokit::Address do

  module MongokitTest
    class User
      include Mongoid::Document

      mongokit :address
      has_address
    end
  end

  let(:model) { MongokitTest::User }

  def address_fields
    @address_fields ||= Mongokit::Address::ClassMethods::ADDRESS_FIELDS.keys.map(&:to_s)
  end

  it 'has address address fields' do
    user_fields = model.fields.keys
    fields = model.address_fields.map(&:to_s)

    expect(user_fields).to include(*fields)
  end

  it 'exclude fields from address fields' do
    model = new_model(:address)
    model.has_address(except: [:latitude, :longitude])

    expect(model.field_names).not_to include(:latitude, :longitude)
  end

  it 'add fields to address fields' do
    model = new_model(:address)
    model.has_address(add: [:flat_no])

    expect(model.field_names).to include('flat_no')
  end

  it 'replace address fields' do
    model = new_model(:address)
    model.has_address(replace: {address_1: :street_1, address_2: :street_2})

    expect(model.field_names).to include('street_1', 'street_2')
    expect(model.field_names).not_to include('address_1', 'address_2')
  end

  it 'returns full address string' do
    user = model.new({
      address_1:   'Studio 103',
      address_2:   'The Business Centre',
      street:      '61 Wellfield Road',
      city:        'Roath',
      state:       'Cardiff',
      postal_code: 'CF24 3DG',
      country:     'England'
    })

    full_address = 'Studio 103, The Business Centre, 61 Wellfield Road, Roath, Cardiff, CF24 3DG, England'
    expect(user.full_address).to eq full_address
  end

end
