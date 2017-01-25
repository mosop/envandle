autoload :FileUtils, "fileutils" unless Object::const_defined?(:FileUtils) && !Object::autoload?(:FileUtils)
autoload :Mutex, "thread" unless Object::const_defined?(:Mutex) && !Object::autoload?(:Mutex)
autoload :Open3, "open3" unless Object::const_defined?(:Open3) && !Object::autoload?(:Open3)
autoload :YAML, "yaml" unless Object::const_defined?(:YAML) && !Object::autoload?(:YAML)
autoload :JSON, "json" unless Object::const_defined?(:JSON) && !Object::autoload?(:JSON)
require "envandle/version"
require "envandle/exceptions"
require "envandle/helper"
require "envandle/binding"

module Envandle
  autoload :Argset, "envandle/argset"
  autoload :AsContext, "envandle/as_context"
  autoload :AsDsl, "envandle/as_dsl"
  autoload :AsGitReference, "envandle/as_git_reference"
  autoload :AsReference, "envandle/as_reference"
  autoload :Element, "envandle/element"
  autoload :Elements, "envandle/elements"
  autoload :GemspecCache, "envandle/gemspec_cache"
  autoload :Gemspec, "envandle/gemspec"
  autoload :GitBranchReference, "envandle/git_branch_reference"
  autoload :GitUtil, "envandle/git_util"
  autoload :History, "envandle/history"
  autoload :IllegalElement, "envandle/illegal_element"
  autoload :Location, "envandle/location"
  autoload :PathReference, "envandle/path_reference"
  autoload :ReferenceCache, "envandle/reference_cache"
  autoload :UnsupportedElement, "envandle/unsupported_element"
end
