require 'spec_helper'

describe Mongokit do

  module MongokitTest
    class TestCollection
      include Mongoid::Document
    end
  end

  let(:model) { MongokitTest::TestCollection }

  it 'has a version number' do
    expect(Mongokit::VERSION).not_to be nil
  end

  it 'returns module names' do
    expect(Mongokit.modules).not_to be_empty
  end

  it 'has "mongokit" method' do
    expect(model).to respond_to(:mongokit)
  end

  it 'include utility modules' do
    model.mongokit :address, :auto_increment

    expect(model.included_modules).to include(Mongokit::Address)
    expect(model.included_modules).to include(Mongokit::AutoIncrement)
  end

  it 'throw error if module not present' do
    expect {
      model.mongokit :module_not_exist
    }.to raise_error(Mongokit::MongokitError)
  end


end
