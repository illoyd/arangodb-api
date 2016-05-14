require 'spec_helper'

def new_person(client)
  handle = client.resource('_api/document').post('name' => Faker::StarWars.droid) do |req|
    req.params['collection'] = 'people'
    req.params['createCollection'] = true
  end.body['_id']
  client.resource('_api/document', handle).get.body
end

RSpec.describe ArangoDB::API::CursorResponse do
  let(:client)     { ArangoDB::Client.new }
  let(:batch_size) { 2 }
  subject          { client.resource('_api/simple/all').put('collection' => 'people', 'batchSize' => batch_size) }

  context 'with 1 item' do
    let(:people) { 1.times.map { new_person(client) } }
    before { people }

    it "is a #{ described_class }" do
      expect( subject ).to be_a(described_class)
    end

    it 'is not empty' do
      expect( subject ).not_to be_empty
    end

    it 'has one item' do
      expect( subject.count ).to eq 1
    end

    it '#to_a returns a single item' do
      expect( subject.to_a ).to match_array(people)
    end

    it 'returns results' do
      expect( subject.result ).to match_array(people)
    end
  end

  context 'with 1 page worth of items' do
    let(:people) { batch_size.times.map { new_person(client) } }
    before { people }

    it "is a #{ described_class }" do
      expect( subject ).to be_a(described_class)
    end

    it 'is not empty' do
      expect( subject ).not_to be_empty
    end

    it 'has one item' do
      expect( subject.count ).to eq batch_size
    end

    it '#to_a returns a single item' do
      expect( subject.to_a ).to match_array(people)
    end

    it 'returns results' do
      expect( subject.result ).to match_array(people)
    end
  end

  context 'with 2 pages worth of items' do
    let(:people_count) { batch_size * 2 }
    let(:people) { people_count.times.map { new_person(client) } }
    before { people }

    it "is a #{ described_class }" do
      expect( subject ).to be_a(described_class)
    end

    it 'is not empty' do
      expect( subject ).not_to be_empty
    end

    it 'has one item' do
      expect( subject.count ).to eq people_count
    end

    it '#to_a returns a single item' do
      expect( subject.to_a ).to match_array(people)
    end

    it 'returns results' do
      expect( subject.result ).to match_array(people)
    end
  end

  context 'with 5 pages worth of items' do
    let(:people_count) { batch_size * 5 }
    let(:people) { people_count.times.map { new_person(client) } }
    before { people }

    it "is a #{ described_class }" do
      expect( subject ).to be_a(described_class)
    end

    it 'is not empty' do
      expect( subject ).not_to be_empty
    end

    it 'has one item' do
      expect( subject.count ).to eq people_count
    end

    it '#to_a returns a single item' do
      expect( subject.to_a ).to match_array(people)
    end

    it 'returns results' do
      expect( subject.result ).to match_array(people)
    end
  end

  context 'with no returned items' do
    it "is a #{ described_class }" do
      expect( subject ).to be_a(described_class)
    end

    it 'returns an empty collection' do
      expect( subject ).to be_empty
    end

    it '#all returns an empty collection' do
      expect( subject.to_a ).to be_empty
    end

    it 'has no items' do
      expect( subject.count ).to be_zero
    end
  end

end
