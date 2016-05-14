require 'spec_helper'

RSpec.describe ArangoDB::API::Database do
  let(:client)        { ArangoDB::Client.new }
  let(:database_name) { "#{ client.uri.database }-#{ Faker::Color.color_name.gsub(/\s/, '_') }" }
  subject             { described_class.new(client, database_name) }

  context 'with an existing database' do
    before { subject.create unless subject.exists? }
    after  { subject.destroy if subject.exists? }

    describe '#exists?' do
      it 'finds the database' do
        expect( subject.exists? ).to be(true)
      end
    end

    describe '#system?' do
      it 'is not a system database' do
        expect( subject.system? ).to eq(false)
      end
    end

    describe '#properties' do
      it 'has a name property' do
        expect( subject.properties['name'] ).to eq(database_name)
      end
      it 'has a isSystem property' do
        expect( subject.properties['isSystem'] ).to eq(false)
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

      it 'decrements the count of databases' do
        expect{ subject.destroy }.to change{ subject.count }.by(-1)
      end

      it 'changes exists? test' do
        expect{ subject.destroy }.to change(subject, :exists?).from(true).to(false)
      end

    end
  end

  context 'with a new database' do
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

      it 'increments the count of databases' do
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
