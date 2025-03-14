# Changelog

## Unreleased

## [1.8.0]

## Changed
- Remove Dependabot
- Add Renovate dependency dashboard
- Update test dependency sinatra to v4
- Update paambaati/codeclimate-action action to v9
- Update build config
- Upgrade Sidekiq to version 8
- Drop Ruby 3.1 suppport

## [1.7.0] - 2023-12-15

### Changed
- Dropped Ruby 2.x support
- Dropped Sidekiq 6.x support
- Updated rspec-sidekiq to 4.1
- Updated sinatra to 3.1
- Updated actions/checkout, actions/upload-artifact and actions/download-artifact to v4
- Updated paambaati/codeclimate-action to v5

## [1.6.0] - 2022-11-02

### Changed
- Updated rubocop to version 1.37 and set the required_ruby_version to >= 2.6
- Update sidekiq dependency to allow version 7

## [1.5.0] - 2022-09-06

### Changed
- Updated max error message length to be configurable
- Updated rack-test requirement from ~> 1.1 to ~> 2.0

## [1.4.1] - 2022-06-03
### Fixed
- Fix downgrade rubocop to '1.28' to keep support for JRuby '9.2.20.1'

## [1.4.0] - 2022-06-03
### Added
- Added a filter based on error messages

### Changed
- Updated rubocop to version 1.30
- Updated rubyzip to version 2.3

### Removed
- Removed Travis CI integration

## [1.3.0] - 2022-04-27
### Added
- Added option to export and re-import dead jobs

## [1.2.0] - 2022-02-03
### Changed
- Updated sidekiq dependency to 6.4.0

## [1.1.1] - 2022-02-03
### Added
- Added CHANGELOG.md

## [1.1.0] - 2022-01-19
### Added
- Added renovate.json
- Added ruby-build github workflow
- Added .rspec config file

### Changed
- Updated support for Sidekiq 6.2.2 and higher
- Updated travis CI config to use latest ruby versions
- Updated to use GitHub-native Dependabot
- Updated spech_helper
- Updated approvals to version 0.0.25

## [1.0.2] - 2021-01-27
### Added
- Consider also explicitly stating that PRs must pass RuboCop to be accepted
- Added rubocop badge to README.md

### Changed
- Upgraded rubocop and rt_rubocop_defaults
- Updated rake requirement from ~> 12.3 to ~> 13.0
- Updated Travis CI to use JRuby-9.2.10.0
- Updated README to clarify RuboCop install

## [1.0.1] - 2020-02-03
### Added
- Added ruby 2.7.0 to travis file and mark ruby 2.4.9 as optional

### Changed
- Updated codeclimate.yml to enable rubocop

### Fixed
- Fixed pagination on morgue page
- Fixed rubocopo issues

## [1.0.0] - 2019-12-24
### Added
- Added RubyGems badge
- Added custom locales

### Changed
- Renamed gem from sidekiq-cleaner to sidekiq-undertaker
- Updated do not show 'all' as job or error name in titles
- Updated gemspec, .travis.yml and README.md
- Updated rename buckets and add the 'older' bucket
- Refactored move sort into JobAggregator
- Renamed JobAggregator to JobDistributor
- Updated translations
- Updated add '/filter' and '/morgue' prefixes to URLs
- Renamed Helpers to APIHelpers
- Moved view files to top level web folder
- Renamed views
- Moved WebExtension::Helper into separate file

### Removed
- Removed before install steps from .travis.yml

### Fixed
- Updated README.md to fix broken members link
- Fixed approvals specs after sidekiq ref update
- Fixed sidekiq dependency in gemspec
- Fixed broken links in filter view
- Fixed Travis link
- Fixed paths in views

## [0.3.6] - 2019-12-04
### Added
- Added Test Coverage Badge
- Added CodeClimate configuration
- Added support for JRuby
- Added .travis.yml
- Added support for csrf and allowed this to be used with newer versions of sidekiq

### Changed
- Updated travis config
- Updated Rubocop and RtRubocopDefaults gems
- Updated README.md
- Updated gemspec
- Renamed approvals specs to shorten file path
- Updated approval specs to exclude Sidekiq::VERSION
- Removed celluloid dependency
- Allowed developers to use other Rubies
- Removed .ruby-version and added .ruby-version and .rvmrc to the .gitignore

### Fixed
- Fixed "Retry All" and "Delete All" function
- Fixed Csrf and sidekiq version compatibility
- Fixed Cleaner Redirect Bug
