# Contributing to Mongoid Collection Snapshot

Fork the project, create a topic branch, make your change with tests, add a line to [CHANGELOG.md](CHANGELOG.md), and open a pull request against `master`.

```sh
bundle install
bundle exec rake
```

The specs need a local MongoDB. `bundle exec rake` runs lint and specs on MRI Ruby 3.3 or newer and only specs on older Ruby versions. Run `bundle exec rake lint` to check Ruby, Markdown, YAML, and spelling, and add reviewed project vocabulary to `.spellcheck.txt`.

The Ruby 4.0 CI job measures library line coverage with SimpleCov and submits `coverage/.resultset.json` to Coveralls using GitHub's automatic token. Other matrix jobs do not submit duplicate reports. Run `COVERAGE=true bundle install` followed by `COVERAGE=true bundle exec rake spec` for a local report. The default-branch badge requires Coveralls to accept an upstream `master` build; configuring this workflow does not activate the external service.
