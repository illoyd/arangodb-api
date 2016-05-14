require 'spec_helper'

RSpec.describe ArangoDB::API::Collection do
  let(:client)          { ArangoDB::Client.new }
  let(:collection_name) { "collection-#{ Faker::Color.color_name.gsub(/\s/, '-') }" }
  subject               { described_class.new(client, collection_name) }

  fcontext 'with an existing collection' do
    before { subject.create unless subject.exists? }
    after  { subject.destroy if subject.exists? }

    describe '#exists?' do
      it 'finds the collection' do
        expect( subject.exists? ).to be(true)
      end
    end

    describe '#properties' do
      it 'has properties' do
        expect( subject.properties ).to be_a(Hash)
      end
      it 'has a name property' do
        expect( subject.properties['name'] ).to eq(collection_name)
      end
    end

    describe '#system?' do
      it 'is not a system collection' do
        expect( subject.system? ).to eq(false)
      end
    end

    describe '#document?' do
      it 'is not a system collection' do
        expect( subject.document? ).to eq(true)
      end
    end

    describe '#system?' do
      it 'is not a system collection' do
        expect( subject.edge? ).to eq(false)
      end
    end

    describe '#type' do
      it 'is a document collection' do
        expect( subject.type ).to eq ArangoDB::API::Collection::Document
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

      it 'decrements the count of collections' do
        expect{ subject.destroy }.to change{ subject.count }.by(-1)
      end

      it 'changes exists? test' do
        expect{ subject.destroy }.to change(subject, :exists?).from(true).to(false)
      end

    end
  end

  context 'with a new collection' do
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

      it 'increments the count of collections' do
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
