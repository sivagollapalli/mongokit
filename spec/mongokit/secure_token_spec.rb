require 'spec_helper'

describe Mongokit::SecureToken do

  module MongokitTest
    class ApiUser
      include Mongoid::Document

      mongokit :secure_token

      has_secure_token :auth_token
    end
  end

  let(:model) { MongokitTest::ApiUser }

  it 'define token field and add index' do
    expect(model.new).to respond_to(:auth_token)

    indexes = model.index_specifications

    expect(indexes.first.fields).to eq([:auth_token])
  end

  it 'set token field on create' do
    model.create

    record = model.first

    expect(record.auth_token).to be_present
  end

  it 'regenerate token' do
    record = model.create
    old_token = record.auth_token

    record.regenerate_auth_token!

    expect(old_token).not_to eq(record.auth_token)
  end

  it 'set token length' do
    model = new_model(:secure_token)
    model.has_secure_token(:auth_token, token_length: 20)

    record = model.create

    expect(record.auth_token.length).to eq 28
  end

  it 'add multiple secure token' do
    model = new_model(:secure_token)
    model.has_secure_token(:public_key)
    model.has_secure_token(:private_key, token_length: 20)

    record = model.create

    expect(record.public_key).to be_present
    expect(record.private_key).to be_present
  end

end
