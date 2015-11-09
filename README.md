# SagaciousSuccotash

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/sagacious_succotash`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sagacious_succotash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sagacious_succotash

## Before Using

* Make sure ruby version in `lib/sagacious_succotash/version.rb` is the latest.
* Make sure rails version in `lib/sagacious_succotash/version.rb` is the latest.

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

  bin/test

## Troubleshooting

* `bundle install` locking up: The first time I ran `bin/test` I had to kill it (Ctrl-C) and go into `tmp/dummy_app` and `bundle install` myself. After that, running `bin/test` worked as expected.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tenforwardconsulting/sagacious\_succotash.

## TODO

1. Use ems instead of px for margin/padding?
2. Do emails have some sort of default style? Add one if there's not.
3. Figure out how to not generate scaffold.sass. There doesn't appear to be an option for it.

## FIXME
Things I know are broken right now that I don't want to forget about:
* _None_

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

