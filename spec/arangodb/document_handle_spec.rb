require 'spec_helper'

class MyVertex; end

describe ArangoDB::DocumentHandle do
  let(:collection)  { 'my_vertices' }
  let(:key)         { 1234 }
  let(:handle)      { "#{ collection }/#{ key }" }
  let(:model_name)  { 'MyVertex' }
  let(:model_class) { MyVertex }

  shared_examples 'acts like a document handle' do
    its(:handle)      { should eq handle }
    its(:collection)  { should eq collection }
    its(:key)         { should eq key }
    its(:model_name)  { should eq model_name }
    its(:model_class) { should eq model_class }

    its(:to_s)        { should eq handle }
    its(:inspect)     { should eq "#<ArangoDB::DocumentHandle #{ handle }>" }

    it 'matches another DocumentHandle(c,k)' do
      expect( described_class.new(collection, key) ).to eq(subject)
    end

    it 'matches another DocumentHandle(handle)' do
      expect( described_class.new(handle) ).to eq(subject)
    end
  end

  context 'with collection and key' do
    subject { described_class.new(collection, key) }
    include_examples 'acts like a document handle'
  end

  context 'with a handle' do
    subject { described_class.new(handle) }
    include_examples 'acts like a document handle'
  end

end
