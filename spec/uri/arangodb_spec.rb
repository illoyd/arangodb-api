require 'spec_helper'

RSpec.describe URI::ArangoDB do

  it 'is registered as a URI schema' do
    expect( URI.scheme_list ).to include('ARANGODB' => described_class )
  end

  it 'parses to a new ArangoDB URI' do
    expect( URI('arangodb://u:p@localhost:1234/my_db') ).to be_a(URI::ArangoDB)
  end

  context 'with typical, fully-formed URI' do
    subject { URI('arangodb://u:p@localhost:1234/my_db') }

    its(:scheme)   { should eq 'arangodb' }
    its(:host)     { should eq 'localhost' }
    its(:port)     { should eq 1234 }
    its(:path)     { should eq '/my_db' }
    its(:database) { should eq 'my_db' }
    its(:query)    { should be_nil }

    its(:userinfo) { should eq 'u:p' }
    its(:user)     { should eq 'u' }
    its(:password) { should eq 'p' }

    its(:to_http_uri) { should eq URI('http://u:p@localhost:1234/_db/my_db') }
  end

  context 'using implicit port' do
    subject { URI('arangodb://localhost/my_db') }
    its(:port)     { should eq described_class::DEFAULT_PORT }
    its('to_http_uri.to_s') { should eq "http://localhost:#{ described_class::DEFAULT_PORT }/_db/my_db" }
  end

  context 'without explicit database' do
    subject { URI('arangodb://localhost') }
    its('to_http_uri.to_s') { should eq "http://localhost:#{ described_class::DEFAULT_PORT }" }
  end

  describe '#database=' do
    subject { URI('arangodb://localhost/my_db') }
    it 'clears on nil' do
      expect{ subject.database = nil }.to change(subject, :database).from('my_db').to(nil)
    end
  end

end
