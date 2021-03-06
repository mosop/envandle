# Envandle

A rubygem for enabling Gemfiles to specify gem locations from environment variables.

[![Build Status](https://travis-ci.org/mosop/envandle.svg?branch=master)](https://travis-ci.org/mosop/envandle)

## Installation

```sh
$ gem install envandle
```

## Usage

Enclose your Gemfile's code with an envandle block.

```ruby
require "envandle"

binding.envandle do
  source "https://rubygems.org"

  gem "mygem", "~> 1.0"
end
```

Set the environment variables.

```sh
export ENVANDLE_GEM_PATH=mygem:/path/to/mygem
```

And execute Bundler.

```sh
$ bundle
```

## Examples

### Setting Paths

You can specify the gem method's `path` option by setting the ENVANDLE_GEM_PATH variable.

For example,

```ruby
ENV["ENVANDLE_GEM_PATH"] = "mygem:/path/to/mygem"

binding.envandle do
  source "https://rubygems.org"

  gem "mygem", "~> 1.0"
end
```

is evaluated as:

```ruby
gem "mygem", path: "/path/to/mygem"
```

If the variable is not set,

```ruby
ENV["ENVANDLE_GEM_PATH"] = ""

binding.envandle do
  source "https://rubygems.org"

  gem "mygem", "~> 1.0"
end
```

is evaluated as:

```ruby
gem "mygem", "~> 1.0"
```

### Setting Git Branches

You can specify the gem method's `git` and `branch` options by setting the ENVANDLE_GEM_GIT_BRANCH variable.

For example,

```ruby
ENV["ENVANDLE_GEM_GIT_BRANCH"] = "mygem:https://github.com/mosop/mygem.git#edge"

envandle do
  source "https://rubygems.org"

  gem "mygem", "~> 1.0"
end
```

is evaluated as:

```ruby
gem "mygem", git: "https://github.com/mosop/mygem.git", branch: "edge"
```

If the variable is not set,

```ruby
ENV["ENVANDLE_GEM_GIT_BRANCH"] = ""

binding.envandle do
  source "https://rubygems.org"

  gem "mygem", "~> 1.0"
end
```

is evaluated as:

```ruby
gem "mygem", "~> 1.0"
```

### Setting Git Commit IDs

You can specify the gem method's `git` and `ref` options by setting the ENVANDLE_GEM_GIT_REF variable.

```ruby
ENV["ENVANDLE_GEM_GIT_REF"] = "mygem:https://github.com/mosop/mygem.git#aed3d9b9965b6938cca7490e98423cf9b5908b09"
```

### Specifying Gemspecs

You can also specify a gemspec not a single gem.

For example, if your gem's name is "mygem", the gemspec refers the a, b and c gems and the c's version requirement is "~> 1.0",

```ruby
ENV["ENVANDLE_GEM_PATH"] = "a:/path/to/a;b:/path/to/b"

binding.envandle do
  source "https://rubygems.org"

  gemspec
end
```

is evaluated as:

```ruby
gem "mygem", path: "."
gem "a", path: "/path/to/a"
gem "b", path: "/path/to/b"
gem "c", "~> 1.0"
```

### Resolving Multilevel Dependencies

For example, if a Gemfile refers the gem a that depends on the gem b, Envandle also tries to resolve the b's reference by the environment variables.

```ruby
ENV["ENVANDLE_GEM_PATH"] = "a:/path/to/a;b:/path/to/b"

binding.envandle do
  source "https://rubygems.org"

  gem "a", "~> 1.0"
end
```

is evaluated as:

```ruby
gem "a", path: "/path/to/a"
gem "b", path: "/path/to/b"
```

## install-envandle

The install-envandle command just installs Envandle itself with the `bundle install` command. It's useful for successfully loading Envandle in your Gemfile with the Bundler's --path option.

```
$ install-envandle -h
install-envandle [OPTIONS]

Installs Envandle using Bundler.

Options:
  --envandle-source      gem source (default: https://rubygems.org)
  --envandle-bundle-bin  command path (default: bundle)

Additionally, you can specify all of the bundle-install's options.
```

### Usage Example

```sh
$ gem install bundler
$ gem install envandle
$ install-envandle --path vendor/bundle
$ bundle install
```
