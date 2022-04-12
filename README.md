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
? Please input app path
>

? Do you want api mode? (Choose with ↑ ↓ ⏎)
> 1. no
  2. yes

? Choose customizes (Toggle options. Choose with ↑ ↓ ⏎, filter with 'f')
> 1. ☐ database (Default: sqlite3)
  2. ☐ javascript (Default: importmap)
  3. ☐ css
  4. ☐ skips
  0. Done

? Choose database (Choose with ↑ ↓ ⏎, filter with 'f')
> 1.  sqlite3
  2.  mysql
  3.  postgresql
  ...

? Choose javascript (Choose with ↑ ↓ ⏎, filter with 'f')
> 1. importmap
  2. webpack
  3. esbuild
  4. rollup

? Choose css (Choose with ↑ ↓ ⏎, filter with 'f')
> 1. tailwind
  2. bootstrap
  3. bulma
  4. postcss
  5. sass

? Choose skips (Toggle options. Choose with ↑ ↓ ⏎, filter with 'f')
> 1. ☐ test
  0. Done
```

### gem

Add gems to rails projects.

```bash
mogu gem
```

```bash
? Choose gems (Toggle options. Choose with ↑ ↓ ⏎, filter with 'f')
> 1. ☐ brakeman
  2. ☐ solargraph
  3. ☐ rspec
  4. ☐ rubocop
  0. Done

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mogurastore/mogu.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
