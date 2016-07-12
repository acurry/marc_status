# MarcStatus

A set of tools to fetch and sort MARC train status data.

**This is currently in active development and is not feature-complete.**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'marc_status'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marc_status

## Usage

```ruby
require 'marc_status'

train_statuses = MarcStatus.find_line_train_statuses(:penn_south)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/marc_status.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

