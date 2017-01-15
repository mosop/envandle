module Envandle
  module AsDsl
    def self.extended(mod)
      mod.class_eval do
        def initialize(e)
          @element = e
        end
      end
    end

    def dsl_method(name)
      name = name.to_s
      class_name = Envandle.pascal(name)
      block_class_name = "#{class_name}Block"
      define_method name do |*args, &block|
        klass = ::Envandle::Elements.const_get(block ? block_class_name : class_name)
        o = klass.new(::Envandle.loc, @element, *args, &block)
        @element << o
        o.draw
      end
    end
  end
end
