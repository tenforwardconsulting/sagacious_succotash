# SagaciousSuccotash

SagaciousSuccotash is a Rails application generator for Ten Forward Consulting.

## Installation

`gem install sagacious_succotash`

## Before Using

* Make sure ruby version in `lib/sagacious_succotash/version.rb` is the latest.
* Make sure rails version in `lib/sagacious_succotash/version.rb` is the latest.

## Usage

    sagacious_succotash path/to/new/project

Afterwards, check the [issues](https://github.com/tenforwardconsulting/sagacious_succotash/issues) for any extra steps you may need to do.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

    bin/test

This creates a dummy project then runs the rspec tests against it.

## Troubleshooting

* `bundle install` locking up: It actually just takes a while to install the gems. Although it seemed to not install them in the correct gemset if the gemset doesn't already exist :/.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tenforwardconsulting/sagacious\_succotash.

## TODO

1. Add rollbar
2. Add option to create api files (this should go in its own generator; probably not even this project. I want to make a 10fw generators gem)
2. Use ems/% instead of px for margin/padding?
3. Extract shared base from application.sass and email.sass to its own file and include it?
4. Figure out how to not generate scaffold.sass. There doesn't appear to be an option for it.
5. Get a better name and put on rubygems.
6. Do issues from [rails\_application\_template](https://github.com/tenforwardconsulting/rails_application_template)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
