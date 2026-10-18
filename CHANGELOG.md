### 1.4.0 (2026/10/18)

* [#20](https://github.com/mongoid/mongoid-collection-snapshot/pull/20): Combine coverage from real legacy and modern Mongoid integration tests - [@dblock](https://github.com/dblock).
* [#18](https://github.com/mongoid/mongoid-collection-snapshot/pull/18): Migrate Danger to use danger-pr-comment workflows, retaining legacy Ruby compatibility - [@dblock](https://github.com/dblock).
* [#19](https://github.com/mongoid/mongoid-collection-snapshot/pull/19): Add `snapshot.collections` discovery from the configured snapshot database, independent of dynamically generated document classes; use the same exact-name matching for cleanup - [@dblock](https://github.com/dblock).

### 1.3.3 (2026/10/14)

* [#17](https://github.com/mongoid/mongoid-collection-snapshot/pull/17): Generate real SimpleCov coverage in one modern CI job and report to Coveralls; scope CI and coverage badges to upstream master - [@dblock](https://github.com/dblock).
* [#17](https://github.com/mongoid/mongoid-collection-snapshot/pull/17): Modernize CI with GitHub Actions through Ruby 4.0, Mongoid 9, and MongoDB Server 8.0; use current Mongoid client and public snapshot storage APIs while retaining legacy coverage - [@dblock](https://github.com/dblock).

### 1.3.2 (2017/06/04)

* [#13](https://github.com/mongoid/mongoid-collection-snapshot/issues/13): Fix: use correct database on all threads - [@dblock](https://github.com/dblock).
* [#7](https://github.com/mongoid/mongoid-collection-snapshot/issues/7): Fix: `max_collection_snapshot_instances` broken - [@dblock](https://github.com/dblock).

### 1.3.1 (2017/05/22)

* [#11](https://github.com/mongoid/mongoid-collection-snapshot/pull/11): Fix: incorrect connection used with Mongoid 6 - [@dblock](https://github.com/dblock).
* [#8](https://github.com/mongoid/mongoid-collection-snapshot/pull/8): Lock mongoid-compatibility at 0.4.0 or newer - [@dblock](https://github.com/dblock).

### 1.3.0 (2017/01/20)

* [#2](https://github.com/mongoid/mongoid-collection-snapshot/pull/2): Support for Mongoid 6 - [@dblock](https://github.com/dblock).
* [#1](https://github.com/mongoid/mongoid-collection-snapshot/pull/1): Gem renamed to mongoid-collection-snapshot and forked to the [mongoid org](https://github.com/mongoid) - [@dblock](https://github.com/dblock).
* [#18](https://github.com/aaw/mongoid_collection_snapshot/pull/18): Fix: classes that include `Mongoid::CollectionSnapshot` can be inherited - [@dblock](https://github.com/dblock).
* [#3](https://github.com/mongoid/mongoid-collection-snapshot/pull/3): Added Danger, PR linter - [@dblock](https://github.com/dblock).
* [#4](https://github.com/mongoid/mongoid-collection-snapshot/pull/4): Added RuboCop - [@dblock](https://github.com/dblock).

### 1.2.0

* [#14](https://github.com/aaw/mongoid_collection_snapshot/pull/14): Compatibility with Mongoid 5 - [@dblock](https://github.com/dblock).

### 1.1.0

* [#11](https://github.com/aaw/mongoid_collection_snapshot/pull/10): Added support for accessing snapshot collection documents via Mongoid::CollectionSnapshot#documents - [@dblock](https://github.com/dblock).
* [#11](https://github.com/aaw/mongoid_collection_snapshot/pull/11): Upgraded RSpec - [@dblock](https://github.com/dblock).

### 1.0.1

* [#8](https://github.com/aaw/mongoid_collection_snapshot/pull/8): Fixed .gemspec for compatibility with Mongoid 4.x - [@dblock](https://github.com/dblock).

### 1.0.0

* Expose `snapshot_session` for custom snapshot storage - [@joeyAghion](https://github.com/joeyAghion).
* Compatibility with Mongoid 4.x - [@dblock](https://github.com/dblock).

### 0.2.0

* Added ability to maintain a snapshot of multiple collections atomically - [@aaw](https://github.com/aaw).
* Added support for [Mongoid 3.0](https://github.com/mongoid/mongoid) - [@dblock](https://github.com/dblock).
* Relaxed version limitations of [mongoid_slug](https://github.com/digitalplaywright/mongoid-slug) - [@dblock](https://github.com/dblock).

### 0.1.0

* Initial public release - [@aaw](https://github.com/aaw).
