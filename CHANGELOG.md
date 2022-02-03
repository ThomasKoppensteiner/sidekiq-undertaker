# Changelog

## Unreleased

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

Upgrade approvals to version 0.0.25

Add .rspec config file

Update spech_helper

Update ruby-build github workflow

Add ruby-build github workflow

Update sidekiq to 6.2.2

Add renovate.json

Upgrade to GitHub-native Dependabot

Update travis CI config to use latest ruby versions

Update support Sidekiq 6.2 and higher

Upgrade rubocop and rt_rubocop_defaults

Update Travis CI setup

Add rubocop badge to README.md #35

Update README to clarify RuboCop install

Consider also explicitly stating that PRs must pass RuboCop to be accepted.

Update travis ci to use JRuby-9.2.10.0

Update rake requirement from ~> 12.3 to ~> 13.0

  Updates the requirements on [rake](https://github.com/ruby/rake) to permit the latest version.
  - [Release notes](https://github.com/ruby/rake/releases)
  - [Changelog](https://github.com/ruby/rake/blob/master/History.rdoc)
  - [Commits](https://github.com/ruby/rake/compare/v12.3.0...v13.0.1)

  Signed-off-by: dependabot-preview[bot] <support@dependabot.com>

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