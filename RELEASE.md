# Release Process

## Setup (one-time)

Add `RUBYGEMS_API_KEY` secret in GitHub: Settings → Secrets → Actions

Get your API key from https://rubygems.org/profile/api_keys

## Release Steps

### 1. Prepare Release
Go to **Actions → Prepare Release → Run workflow** and enter the version (e.g., `0.2.0`)

This creates a PR with:
- Updated `lib/better_appgen/version.rb`
- Updated `CHANGELOG.md`

### 2. Review and Merge
Review the PR and merge to main.

That's it! After merge:
1. Tag is created automatically
2. Tests run
3. Gem is published to RubyGems
4. GitHub Release is created
