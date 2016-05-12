# ArangoDB::API

The ArangoDB::API and ArangoDB::Client provide a simple wrapper around the ArangoDB HTTP REST API, allowing for relatively easy, programatic access to the API.

The API includes additional object-oriented helpers for common components, such as Databases and Graphs.

The Client is built using the excellent Faraday library, and is extended with simple helpers to give it a more resource-oriented feel.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arangodb-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arangodb-api

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/arangodb-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

