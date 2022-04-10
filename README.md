# Mogu

CLI to create rails projects interactively.

## Prerequisites

- Rails 7+

## Features

- Support in selecting rails new options
  - database
  - javascript
  - css
  - skips
- Support in adding gems

## Installation

```bash
gem install mogu
```

## Usage

### help

```bash
mogu help
```

### new

Create rails projects interactively.

```bash
mogu new
```

```bash
Please input app path

Do you want api mode? (y/N)

Choose customizes
> ⬡ database (Default: sqlite3)
  ⬡ javascript (Default: importmap)
  ⬡ css
  ⬡ skips

Choose database
> sqlite3
  mysql
  postgresql
  ...

Choose javascript
> importmap
  webpack
  esbuild
  rollup

Choose css
> tailwind
  bootstrap
  bulma
  postcss
  sass

Choose skips
> ⬡ test
```

### gem

Add gems to rails projects.

```bash
mogu gem
```

```bash
Choose gems
> ⬡ brakeman
  ⬡ solargraph
  ⬡ rspec
  ⬡ rubocop
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mogurastore/mogu.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
