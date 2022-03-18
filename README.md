# Mogu

CLI to create rails projects interactively.

## Prerequisites

- Rails 7+

## Features

- Support for rails new option selection.

## Installation

```bash
gem install mogu
```

## Usage

```bash
mogu
```

```bash
Please input app path

Choose customizes
> ⬡ database
  ⬡ javascript
  ⬡ css
  ⬡ gems

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

Choose gems
> ⬡ rspec
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mogurastore/mogu.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
