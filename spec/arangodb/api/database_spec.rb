require 'spec_helper'

describe ArangoDB::API::Database do
  let(:client) { ArangoDB::API::Client.new }
  subject { described_class.new(client, "test-#{ Faker::Color.color_name }") }

  context 'with an existing database' do
    before { subject.create }

    describe '#exists?' do
      expect( subject.create ).to be_falsey
    end

    describe '#create' do
      it 'raises an error' do
        expect{ subject.create }.not_to raise_error
      end
    end

    describe '#destroy' do
    end
  end

  context 'with a new database' do
    describe '#exists?' do
      it 'is false' do
        expect( subject.create ).to be_falsey
      end
    end

    describe '#create' do
      it 'does not error' do
        expect{ subject.create }.not_to raise_error
      end

      it 'increments the count of databases' do
        expect{ subject.create }.to change{ client.resource('/_db/_system').get.body['results'].count }.by(1)
      end

    end

    describe '#destroy' do
    end
  end

end
