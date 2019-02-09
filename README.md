# Sidekiq::Cleaner

[![Build Status](https://travis-ci.org/ThomasKoppensteiner/sidekiq-cleaner.svg?branch=master)](https://travis-ci.org/ThomasKoppensteiner/sidekiq-cleaner)
[![Code Climate](https://codeclimate.com/github/ThomasKoppensteiner/sidekiq-cleaner.svg)](https://codeclimate.com/github/ThomasKoppensteiner/sidekiq-cleaner)

## About

Sidekiq::Cleaner is a plugin for [Sidekiq](https://rubygems.org/gems/sidekiq).
It makes exploring the dead job queue easier
by breaking down the dead jobs into time windows (buckets) of hours and days.
The gems allows retrying or deleting a certain subset of failures.

## Installation

Add this line to your application's Gemfile:

````ruby
  gem "sidekiq-cleaner", git: "https://github.com/ThomasKoppensteiner/sidekiq-cleaner"
````

And then execute:
````sh
  $ bundle
````

<!-- Show, when released at rubygems -->
<!--
Or install it yourself as:

    $ gem install sidekiq-cleaner -->

## Impressions

**Attention** The following demo images are
[outdated and need the be recreated](https://github.com/ThomasKoppensteiner/sidekiq-cleaner/issues/2), but the still give a good impression how the views of the plugin look like.

#### Overview

The overview page shows a table with time-buckets as columns and rows for each job class.

![Sidekiq Cleaner](Demo1.png)

#### Job View

For each job class, you can drill down to view failure distribution based on
error class.

![Sidekiq Cleaner](Demo2.png)

#### Detail View
Finally, click on the individual error counts to display details of the
errors in a list form.

![Sidekiq Cleaner](Demo3.png)

## Contributing

1. Fork it ( https://github.com/ThomasKoppensteiner/sidekiq-cleaner/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

The [Sidekiq-Cleaner](https://github.com/HackingHabits/sidekiq-cleaner) gem was originally created by [Madan Thangavelu](https://github.com/HackingHabits).
[Tout](https://github.com/Tout/sidekiq-cleaner) and [TheWudu](https://github.com/TheWudu/sidekiq-cleaner) also contributed to it.
For the complete list of network members have a look at the [fork overview](https://github.com/ThomasKoppensteiner/sidekiq-cleaner/network/members).

## Author

Thomas Koppensteiner | [Github](https://github.com/ThomasKoppensteiner) | [RubyGems](https://rubygems.org/profiles/thomaskoppensteiner) | [@koppensteiner_t](https://twitter.com/koppensteiner_t)

## License

See the [License](https://github.com/ThomasKoppensteiner/sidekiq-cleaner/blob/master/LICENSE.txt) file.
