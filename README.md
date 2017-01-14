# Envandle

A rubygem for enabling Gemfiles to specify gem locations from environment variables.

## Installation

```sh
$ gem install envandle
```

## Usage

Write a Gemfile.

```ruby
require "envandle"

source "https://rubygems.org"

binding.envandle do |bundle|
  bundle.gem "mygem", "~> 1.0"
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

binding.envandle do |bundle|
  bundle.gem "mygem", "~> 1.0"
end
```

is evaluated as:

```ruby
gem "mygem", path: "/path/to/mygem"
```

If the variable is not set,

```ruby
ENV["ENVANDLE_GEM_PATH"] = ""

binding.envandle do |bundle|
  bundle.gem "mygem", "~> 1.0"
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

binding.envandle do |bundle|
  bundle.gem "mygem", "~> 1.0"
end
```

is evaluated as:

```ruby
gem "mygem", git: "https://github.com/mosop/mygem.git", branch: "edge"
```

If the variable is not set,

```ruby
ENV["ENVANDLE_GEM_GIT_BRANCH"] = ""

binding.envandle do |bundle|
  bundle.gem "mygem", "~> 1.0"
end
```

is evaluated as:

```ruby
gem "mygem", "~> 1.0"
```

### Specifying Gemspecs

As well as the regular Gemfile, you can also specify a gemspec not a single gem.

For example, if your gem's name is "mygem", the gemspec refers the a, b and c gems and the c's version requirement is "~> 1.0",

```ruby
ENV["ENVANDLE_GEM_PATH"] = "a:/path/to/a;b:/path/to/b"

binding.envandle do |bundle|
  bundle.gemspec
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

binding.envandle do |bundle|
  bundle.gem "a", "~> 1.0"
end
```

is evaluated as:

```ruby
gem "a", path: "/path/to/a"
gem "b", path: "/path/to/b"
```