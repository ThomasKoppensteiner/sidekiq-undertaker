# Sidekiq::Undertaker

[![Gem Version](https://badge.fury.io/rb/sidekiq-undertaker.svg)](https://badge.fury.io/rb/sidekiq-undertaker)
[![Ruby-Build](https://github.com/ThomasKoppensteiner/sidekiq-undertaker/actions/workflows/ruby-build.yml/badge.svg)](https://github.com/ThomasKoppensteiner/sidekiq-undertaker/actions/workflows/ruby-build.yml)
[![Code Climate](https://codeclimate.com/github/ThomasKoppensteiner/sidekiq-undertaker.svg)](https://codeclimate.com/github/ThomasKoppensteiner/sidekiq-undertaker)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d442eb0a323d8911661f/test_coverage)](https://codeclimate.com/github/ThomasKoppensteiner/sidekiq-undertaker/test_coverage)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)

## About

Sidekiq::Undertaker is a plugin for [Sidekiq](https://rubygems.org/gems/sidekiq).
It allows exploring, reviving (retrying) or burying (deleting) dead jobs.
For easy exploring the dead-jobs queue is broken down into time windows (buckets) of hours, days and weeks.

## Installation

#### Install the Gem

Add this line to your application's Gemfile:

````ruby
  gem "sidekiq-undertaker"
````

And then execute:
````sh
  $ bundle
````

Or install it yourself as:

````sh
  $ gem install sidekiq-undertaker
````

#### Development: Install the Rubocop Pre-Commit Hook

````sh
  $ rake rubocop:install
````

## Impressions

#### Filter View

The filter page shows a table with time-buckets as columns and rows for each job class.

![Sidekiq Undertaker](assets/Undertaker_demo_all_jobs.png)

#### Job Filter View

For each job class, you can drill down to view error distribution based on
error class.

![Sidekiq Undertaker](assets/Undertaker_demo_1_job_all_errors.png)

#### Morgue View
Finally, click on the individual error counts to display details of the
errors in a list form.

![Sidekiq Undertaker](assets/Undertaker_demo_1_job_1_error.png)

The morgue view can, for example, also show an error distribution over all job classes.

![Sidekiq Undertaker](assets/Undertaker_demo_all_jobs_1_error.png)

## Contributing

1. Fork it ( https://github.com/ThomasKoppensteiner/sidekiq-undertaker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Naming

As another gem with the name `sidekiq-cleaner` is already released on rubygems.org,
this fork was renamed to `sidekiq-undertaker`.

## Thanks

The [Sidekiq-Cleaner](https://github.com/HackingHabits/sidekiq-cleaner) gem was originally created by [Madan Thangavelu](https://github.com/HackingHabits).
[Tout](https://github.com/Tout/sidekiq-cleaner) and [TheWudu](https://github.com/TheWudu/sidekiq-cleaner) also contributed to it.
[Zlatko Rednjak](https://github.com/Rednjak) added the initial version of the `CHANGELOG.md`.
[Lucas Dell'Isola](https://github.com/ldellisola) added the export/import feature for dead jobs.
[thoesl](https://github.com/thoesl) added the error message based filter.

For the complete list of network members have a look at the [fork overview](https://github.com/ThomasKoppensteiner/sidekiq-undertaker/network/members).

## Alternative Projects

* [sidekiq-cleaner](https://rubygems.org/gems/sidekiq-cleaner)
* [sidekiq_cleaner](https://rubygems.org/gems/sidekiq_cleaner)

## Author

Thomas Koppensteiner | [Github](https://github.com/ThomasKoppensteiner) | [RubyGems](https://rubygems.org/profiles/thomaskoppensteiner) | [@koppensteiner_t](https://twitter.com/koppensteiner_t)

## License

See the [License](https://github.com/ThomasKoppensteiner/sidekiq-under/blob/master/LICENSE.txt) file.
