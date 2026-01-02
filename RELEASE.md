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

### 3. Tag and Publish
```bash
git checkout main && git pull
git tag v0.2.0
git push origin v0.2.0
```

The release workflow automatically:
- Verifies version consistency
- Runs tests
- Publishes to RubyGems
- Creates GitHub Release
