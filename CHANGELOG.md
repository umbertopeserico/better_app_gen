# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-01-16

### Added

- Production Docker support with multi-stage Dockerfile, Thruster, Jemalloc, and YJIT
- DEPLOY.md documentation for production deployments
- Comprehensive test suite with SimpleCov coverage
- better_vite_helper gem for improved Vite integration

### Changed

- Silenced RuboCop deprecation warnings for renamed cops

## [0.1.0] - 2026-01-02

### Added

- Initial release of better_app_gen gem
- CLI for generating Rails 8 applications with `new`, `check`, and `version` commands
- Solid Stack integration (Cache, Queue, Cable) backed by PostgreSQL
- Vite 7 + Tailwind CSS 4 + Stimulus frontend setup
- Multi-database PostgreSQL configuration (primary, cache, queue, cable)
- UUID primary keys by default across all models
- Docker development environment with helper scripts (dc-up, dc-down, dc-shell, etc.)
- Configurable locale support (en, it, de, fr, es, pt, nl, pl, ru, ja, zh)
- Optional SimpleForm integration with Tailwind styling
- Configurable Rails and Vite server ports
- Comprehensive dependency checking (Ruby, Rails, Node, Yarn, Git, PostgreSQL)
- CLAUDE.md for Claude Code guidance
- GitHub Actions workflows for CI and release
- RELEASE.md with release process documentation
