require 'spec_helper'

describe ArangoDB::API do
  it 'has a version number' do
    expect(ArangoDB::API::VERSION).not_to be nil
  end
end
