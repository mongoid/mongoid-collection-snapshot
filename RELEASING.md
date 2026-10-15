# Releasing Mongoid Collection Snapshot

## Prepare

Use the upstream checkout on clean `master`, verify `origin` points to `mongoid/mongoid-collection-snapshot`, and run `git pull --ff-only`. Check supported platforms in [GitHub Actions](https://github.com/mongoid/mongoid-collection-snapshot/actions). Choose a patch version for fixes, minor for backward-compatible features, or major for breaking changes.

Set `lib/mongoid-collection-snapshot/version.rb` to the release version. Date the matching changelog section using `YYYY/MM/DD` and remove its contribution placeholder.

```sh
bundle install
bundle exec rake
git add CHANGELOG.md lib/mongoid-collection-snapshot/version.rb RELEASING.md
git commit -m "Preparing for release, 1.3.3."
git push origin master
```

Wait for the preparation commit's CI checks to pass.

## Publish RubyGems and GitHub

```sh
bundle exec rake release
```

Complete RubyGems MFA when prompted. This builds the package, pushes the tag, and publishes to RubyGems. If interrupted, inspect existing tags and the RubyGems version before retrying. Never move published tags; if only publication is missing, use `gem push pkg/mongoid-collection-snapshot-1.3.3.gem`.

A tag alone does not create a GitHub release. Once RubyGems publication is verified, publish a matching GitHub release with changelog notes:

```sh
version=1.3.3
notes="$(mktemp)"
awk -v version="$version" '
  /^### / {
    if (found) exit
    if ($2 == version) found = 1
    next
  }
  found { print }
' CHANGELOG.md > "$notes"
gh release create "v$version" --repo mongoid/mongoid-collection-snapshot --verify-tag --title "$version" --notes-file "$notes" --latest
rm "$notes"
curl --fail --silent --show-error "https://rubygems.org/api/v2/rubygems/mongoid-collection-snapshot/versions/$version.json"
gh release view "v$version" --repo mongoid/mongoid-collection-snapshot
```

Verify both the published gem and non-draft GitHub release.

## Prepare the Next Version

Increment the development patch version in `lib/mongoid-collection-snapshot/version.rb` (for example, `1.3.4`). Add `### 1.3.4 (Next)` with a contribution placeholder above the released changelog section. Commit and push those changes to `master` without changing the release tag.
