require 'spec_helper'

RSpec.describe ArangoDB::API::Graph do
  let(:client)        { ArangoDB::Client.new }
  let(:graph_name)    { "#{ client.uri.database }-#{ Faker::Color.color_name.gsub(/\s/, '_') }" }
  subject             { described_class.new(client, graph_name) }

  context 'with an existing graph' do
    before { subject.create unless subject.exists? }
    after  { subject.destroy if subject.exists? }

    describe '#exists?' do
      it 'finds the graph' do
        expect( subject.exists? ).to be(true)
      end
    end

    describe '#properties' do
      it 'has properties' do
        expect( subject.properties ).to be_a(Hash)
      end
      it 'has a name property' do
        expect( subject.properties['name'] ).to eq(graph_name)
      end
      it 'has a orphanCollections property' do
        expect( subject.properties['orphanCollections'] ).to be_a(Array)
      end
      it 'has a edgeDefinitions property' do
        expect( subject.properties['edgeDefinitions'] ).to be_a(Array)
      end
    end

    describe '#create' do
      it 'raises an error' do
        expect{ subject.create }.to raise_error(ArangoDB::API::DuplicateResourceName)
      end
    end

    describe '#destroy' do
      it 'does not error' do
        expect{ subject.destroy }.not_to raise_error
      end

      it 'decrements the count of graphs' do
        expect{ subject.destroy }.to change{ subject.count }.by(-1)
      end

      it 'changes exists? test' do
        expect{ subject.destroy }.to change(subject, :exists?).from(true).to(false)
      end

    end
  end

  context 'with a new graph' do
    before { subject.destroy if subject.exists? }
    after  { subject.destroy if subject.exists? }

    describe '#exists?' do
      it 'is false' do
        expect( subject.exists? ).to be(false)
      end
    end

    describe '#create' do
      it 'does not error' do
        expect{ subject.create }.not_to raise_error
      end

      it 'increments the count of graphs' do
        expect{ subject.create }.to change{ subject.count }.by(1)
      end

      it 'changes exists? test' do
        expect{ subject.create }.to change(subject, :exists?).from(false).to(true)
      end
    end

    describe '#destroy' do
      it 'raises an error' do
        expect{ subject.destroy }.to raise_error(ArangoDB::API::ResourceNotFound)
      end
    end
  end

end
