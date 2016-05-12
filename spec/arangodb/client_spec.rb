require 'spec_helper'

RSpec.describe ArangoDB::Client do

  describe 'get Google for testing' do
    let(:url) { 'http://www.google.com' }
    let(:uri) { URI(url) }
    subject { described_class.new(uri) }

    it 'HEAD google.com' do
      expect{ subject.head }.not_to raise_error
    end
  end

  context 'with an ArangoDB URI' do
    let(:url) { 'arangodb://localhost' }
    subject { described_class.new(url) }

    it 'connects' do
      expect{ subject.head }.not_to raise_error
    end
  end

  describe '#uri' do

    context 'with an arangodb:// style URL' do
      let(:url) { 'arangodb://localhost' }
      let(:uri) { URI(url) }

      it 'converts a string URL to URI::ArangoDB' do
        expect( described_class.new(url).uri ).to be_a(URI::ArangoDB)
      end

      it 'accepts a URI::ArangoDB URI' do
        expect( described_class.new(uri).uri ).to be_a(URI::ArangoDB)
      end
    end

    context 'with an http:// style URL' do
      let(:url) { 'http://localhost:5829' }
      let(:uri) { URI(url) }

      it 'converts a string URL to URI::ArangoDB' do
        expect( described_class.new(url).uri ).to be_a(URI::HTTP)
      end

      it 'accepts a URI::ArangoDB URI' do
        expect( described_class.new(uri).uri ).to be_a(URI::HTTP)
      end
    end

  end #uri

  describe '.default_uri' do

    context 'with ARANGODB_URI' do
      it 'detects the ENV URL' do
        with_modified_env ARANGODB_URI: 'arangodb://localhost/another_db' do
          expect( ArangoDB::Client.default_uri ).to eq(URI('arangodb://localhost/another_db'))
        end
      end
    end

    context 'with blank ARANGODB_URI' do
      it 'returns nil' do
        with_modified_env ARANGODB_URI: '' do
          expect( ArangoDB::Client.default_uri ).to be_nil
        end
      end
    end

    context 'with ARANGODB_PROVIDER pointing to OTHER_URI' do
      it 'uses ENV defined by PROVIDER' do
        with_modified_env ARANGODB_PROVIDER: 'OTHER_URI', OTHER_URI: 'arangodb://localhost/more_db' do
          expect( ArangoDB::Client.default_uri ).to eq(URI('arangodb://localhost/more_db'))
        end
      end
    end

    context 'with ARANGODB_PROVIDER pointing to an undefined ENV' do
      it 'returns nil' do
        with_modified_env ARANGODB_PROVIDER: 'MISTAKEN_ENV' do
          expect( ArangoDB::Client.default_uri ).to be_nil
        end
      end
    end

  end

end
