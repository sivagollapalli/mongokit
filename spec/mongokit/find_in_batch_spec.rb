require 'spec_helper'

describe Mongokit::FindInBatch do

  module MongokitTest
    class Event
      include Mongoid::Document

      field :name
      field :no, type: Integer
    end
  end

  let(:model) { MongokitTest::Event }

  it 'find in batch of 2' do
    10.times do |i|
      model.create(name: "event_#{i}", no: i)
    end

    counter = 0

    model.in_batches(batch_size: 2) do |events|
      expect(events.length).to eq 2
      counter += 1
    end

    expect(counter).to eq 5
  end

  it 'find in batch with scope' do
    10.times do |i|
      model.create(name: "event_#{i}", no: i)
    end

    counter = 0

    model.where(:no.gt => 3).in_batches(batch_size: 2) do |events|
      expect(events.length).to eq 2
      counter += 1
    end

    expect(counter).to eq 3
  end

end
