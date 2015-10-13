# celluloid-io-pg-listener

Simple way to NOTIFY and LISTEN to channels in PostgreSQL

Inspired by https://gist.github.com/tpitale/3915671

| Project                 |  Celluloid IO PG Listener   |
|------------------------ | ----------------- |
| gem name                |  celluloid-io-pg-listener   |
| license                 |  MIT              |
| moldiness               |  [![Maintainer Status](http://stillmaintained.com/pboling/celluloid-io-pg-listener.png)](http://stillmaintained.com/pboling/celluloid-io-pg-listener) |
| version                 |  [![Gem Version](https://badge.fury.io/rb/celluloid-io-pg-listener.png)](http://badge.fury.io/rb/celluloid-io-pg-listener) |
| dependencies            |  [![Dependency Status](https://gemnasium.com/pboling/celluloid-io-pg-listener.png)](https://gemnasium.com/pboling/celluloid-io-pg-listener) |
| code quality            |  [![Code Climate](https://codeclimate.com/github/pboling/celluloid-io-pg-listener.png)](https://codeclimate.com/github/pboling/celluloid-io-pg-listener) |
| inline documenation     |  [![Inline docs](http://inch-ci.org/github/pboling/celluloid-io-pg-listener.png)](http://inch-ci.org/github/pboling/celluloid-io-pg-listener) |
| continuous integration  |  [![Build Status](https://secure.travis-ci.org/pboling/celluloid-io-pg-listener.png?branch=master)](https://travis-ci.org/pboling/celluloid-io-pg-listener) |
| test coverage           |  [![Coverage Status](https://coveralls.io/repos/pboling/celluloid-io-pg-listener/badge.png)](https://coveralls.io/r/pboling/celluloid-io-pg-listener) |
| homepage                |  [https://github.com/pboling/celluloid-io-pg-listener][homepage] |
| documentation           |  [http://rdoc.info/github/pboling/celluloid-io-pg-listener/frames][documentation] |
| author                  |  [Peter Boling](https://coderbits.com/pboling) |
| Spread ~♡ⓛⓞⓥⓔ♡~      |  [![Endorse Me](https://api.coderwall.com/pboling/endorsecount.png)](http://coderwall.com/pboling) |


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'celluloid-io-pg-listener'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install celluloid-io-pg-listener

## Usage

Find a data base that exists that you want to run notifications through.  Won't affect anything else in the database,
so doesn't matter which one you pick.  Then pick an arbitrary name for the channel.  Only requirement is that the server
and the client use the same database name and channel name or they won't be communicating.

In an irb session

```ruby
>> require "celluloid-io-pg-listener"

=> true

>> CelluloidIOPGListener::Server.new(dbname: "test_database", channel: "test_channel" )

I, [2015-10-06T12:38:43.728686 #5880]  INFO -- : Server will send notifications to archer_test:test

=> #<Celluloid::Proxy::Cell(CelluloidIOPGListener::Server:0x3ff732194f24) @dbname="test_database" @channel="test_channel" @sleep_interval=0.1 @run_interval=1>

I, [2015-10-06T12:38:44.105265 #5880]  INFO -- : Notified test

>> CelluloidIOPGListener::Listener.new(dbname: "test_database", channel: "test_channel" )

=> #<Celluloid::Proxy::Cell(CelluloidIOPGListener::Listener:0x3fd6ace33cb8) @dbname="test_database" @listening=true @pg_connection=#<PG::Connection:0x007fad59c5f978> @actions={"test_channel"=>:do_something}>

I, [2015-10-06T12:40:38.110541 #5952]  INFO -- : Client will for notifications on test_database:test_channel
I, [2015-10-06T12:40:38.110822 #5952]  INFO -- : Starting Listening
I, [2015-10-06T12:40:50.117444 #5952]  INFO -- : Received notification: ["test", 5968, "1444160450"]
I, [2015-10-06T12:40:50.117518 #5952]  INFO -- : Doing Something with Payload: 1444160450 on test
I, [2015-10-06T12:40:50.117541 #5952]  INFO -- : 1444160450
I, [2015-10-06T12:40:51.107977 #5952]  INFO -- : Received notification: ["test", 5968, "1444160451"]
I, [2015-10-06T12:40:51.108071 #5952]  INFO -- : Doing Something with Payload: 1444160451 on test
I, [2015-10-06T12:40:51.108104 #5952]  INFO -- : 1444160451
I, [2015-10-06T12:40:52.112797 #5952]  INFO -- : Received notification: ["test", 5968, "1444160452"]
I, [2015-10-06T12:40:52.112881 #5952]  INFO -- : Doing Something with Payload: 1444160452 on test
I, [2015-10-06T12:40:52.112911 #5952]  INFO -- : 1444160452
```

The Listener class included is just a proof of concept.  It shows you how to use the Client module to make your own listener class that does what you need done.

```ruby
module CelluloidIOPGListener
  # An example Client class
  class Listener

    include CelluloidIOPGListener::Client

    def initialize(dbname:, channel:)
      info "Client will for notifications on #{dbname}:#{channel}"
      @dbname = dbname
      async.start_listening
      async.listen(channel, :do_something)
    end

    def do_something(channel, payload)
      unlisten_wrapper(channel, payload) do
        info payload
      end
    end

  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies, and setup the test environment, including creating a role and a database. Then, run `appraisal rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Running the tests

Setup has been implemented with `bin/setup`, so review the file to see what it will do before you:

    bin/setup

Run the specs with rake:

    appraisal rake

Or, run the specs without rake:

    appraisal rspec

NOTE: If you need to recreate `db/structure.sql` from the contents of the test database:

    SKIP_RAILS_ROOT_OVERRIDE=true bundle exec rake db:structure:dump

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/celluloid-io-pg-listener. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
6. Create new Pull Request

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver].
Violations of this scheme should be reported as bugs. Specifically,
if a minor or patch version is released that breaks backward
compatibility, a new version should be immediately released that
restores compatibility. Breaking changes to the public API will
only be introduced with new major versions.

As a result of this policy, you can (and should) specify a
dependency on this gem using the [Pessimistic Version Constraint][pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency 'celluloid-io-pg-listener', '~> 0.1'
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74
[railsbling]: http://www.railsbling.com
[documentation]: http://rdoc.info/github/pboling/celluloid-io-pg-listener/frames
[homepage]: https://github.com/pboling/celluloid-io-pg-listener
