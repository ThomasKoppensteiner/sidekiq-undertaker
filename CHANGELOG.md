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

## 1.0.1 (2020-02-03)

### Bug fixes
- Fix pagination on morgue page

### Development
-  Fix rubocopo issues
-  Add ruby 2.7.0 to travis file and mark ruby 2.4.9 as optional
-  Update codeclimate.yml to enable rubocop

## 1.0.0 (2019-12-24)

### Development
- Update README.md to fix broken members link
- Remove before install steps from .travis.yml
- Fix approvals specs after sidekiq ref update

commit a2023d7999bb53d2fd313c6d077b4a4fd74eb1ee
Author: Thomas Koppensteiner <thomas.koppensteiner@space-4.me>
Date:   Mon Dec 16 12:36:44 2019 +0100

    Bump version (1.0.0.rc04)

    fix sidekiq dependency in gemspec

    commit fbcb83420acc816ffcd0e00c4d225d7d9dfdde16
    Author: Thomas Koppensteiner <thomas.koppensteiner@space-4.me>
    Date:   Wed Dec 11 22:09:57 2019 +0100

        Bump version (rc03)

        Update do not show 'all' as job or error name in titles

        Fix broken links in filter view

        commit 2134c9fd358bddda33cf9b47fa61e0886949292e
        Author: Thomas Koppensteiner <thomas.koppensteiner@space-4.me>
        Date:   Tue Dec 10 22:15:12 2019 +0100

            Bump version (rc02)

            Merge branch 'master' of github.com:ThomasKoppensteiner/sidekiq-cleaner

            Update gemspec

            Update README.md

            Add RubyGems badge

            Update README.md

            Update .travis.yml

            Update CC_TEST_REPORTER_ID

            Update .travis.yml

            Update README.md

            Update CC_TEST_REPORTER_ID in travis.yml

            Update README.md

            Fix Travis link

            Update README.md

            Update rename buckets and add the 'older' bucket

            Rename JobAggregator to JobDistributor

            Update transaltions

            Update paths in views

            Refactor move sort into JobAggregator

            Update add '/filter' and '/morgue' prefixes to URLs

            Rename Helpers to APIHelpers

            Move view files to top level web folder

            Rename views

            Move WebExtension::Helper into separate file

            Add custom locales

            Rename gem from sidekiq-cleaner to sidekiq-undertaker


## [0.x]


---














Author: Thomas Koppensteiner <thomas.koppensteiner@space-4.me>
Date:   Wed Dec 4 21:35:06 2019 +0100

    Bump version (0.3.6)

    Update travis config

    Update Rubocop and RtRubocopDefaults gems

    Fix typo in README.md

    Update README.md

    Add Test Coverage Badge

    Add CodeClimate configuration (#12)

    Add CodeClimate configuration

---
    Bump version (0.3.5)

    Add support for JRuby

---
    Bump version (0.3.4)

    Update gemspec

    Rename approvals specs to shorten file path


    Bump version (0.3.3)

    Update README and gemspec

    Bump version (0.3.2)

    Fix "Retry All" and "Delete All" function

    Add .travis.yml

    Update approval specs to exclude Sidekiq::VERSION

    Bump version (0.3.1)

    Refactor code base

      Fix specs
      Add Rubocop
      Add SimpleCov

    Fix strange version

    Remove celluloid dependency

    Csrf fix and sidekiq version compatibility

    Bump version (0.2.0)

    Add support for csrf and allow this to be used with newer versions of sidekiq

    Allow developers to use other Rubies

    Remove .ruby-version and add .ruby-version and .rvmrc to the .gitignore

    Fix Cleaner Redirect Bug

    Updating screenshots

    Cleanup README.md

    Initial commit sidekiq cleaner
