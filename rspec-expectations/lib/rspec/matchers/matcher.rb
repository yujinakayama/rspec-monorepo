require 'set'

module RSpec
  module Matchers
    module DSL
      # Provides the context in which the block passed to RSpec::Matchers.define
      # will be evaluated.
      class Matcher
        include RSpec::Matchers::Extensions::InstanceEvalWithArgs
        include RSpec::Matchers::Pretty
        include RSpec::Matchers

        attr_reader :expected, :actual, :rescued_exception

        # @api private
        def initialize(name, &declarations)
          @name         = name
          @declarations = declarations
          @actual       = nil
          @diffable     = false
          @expected_exception, @rescued_exception = nil, nil
          @match_for_should_not_block = nil
          @messages = {}
        end

        PERSISENT_INSTANCE_VARIABLES = [
          :@name, :@declarations, :@diffable, :@messages,
          :@match_block, :@match_for_should_not_block,
          :@expected_exception
        ].to_set

        # @api private
        def for_expected(*expected)
          @expected = expected
          dup.instance_eval do
            instance_variables.map {|ivar| ivar.intern}.each do |ivar|
              instance_variable_set(ivar, nil) unless (PERSISENT_INSTANCE_VARIABLES + [:@expected]).include?(ivar)
            end
            making_declared_methods_public do
              instance_eval_with_args(*@expected, &@declarations)
            end
            self
          end
        end

        # @api private
        # Used internally by +should+ and +should_not+.
        def matches?(actual)
          @actual = actual
          if @expected_exception
            begin
              instance_eval_with_args(actual, &@match_block)
              true
            rescue @expected_exception => @rescued_exception
              false
            end
          else
            begin
              instance_eval_with_args(actual, &@match_block)
            rescue RSpec::Expectations::ExpectationNotMetError
              false
            end
          end
        end

        # Stores the block that is used to determine whether this matcher passes
        # or fails. The block should return a boolean value. When the matcher is
        # passed to `should` and the block returns `true`, then the expectation
        # passes. Similarly, when the matcher is passed to `should_not` and the
        # block returns `false`, then the expectation passes.
        #
        # Use `match_for_should` when used in conjuntion with
        # `match_for_should_not`.
        #
        # @example
        #
        #     RSpec::Matchers.define :be_even do
        #       match do |actual|
        #         actual.even?
        #       end
        #     end
        #
        #     4.should be_even     # passes
        #     3.should_not be_even # passes
        #     3.should be_even     # fails
        #     4.should_not be_even # fails
        #
        # @yield [Object] actual the actual value (or receiver of should)
        def match(&block)
          @match_block = block
        end

        alias_method :match_for_should, :match

        # Use this to define the block for a negative expectation (`should_not`)
        # when the positive and negative forms require different handling. This
        # is rarely necessary, but can be helpful, for example, when specifying
        # asynchronous processes that require different timeouts.
        #
        # @yield [Object] actual the actual value (or receiver of should)
        def match_for_should_not(&block)
          @match_for_should_not_block = block
        end

        # Use this instead of `match` when the block will raise an exception
        # rather than returning false to indicate a failure.
        #
        # @example
        #
        #     RSpec::Matchers.define :accept_as_valid do |candidate_address|
        #       match_unless_raises ValidationException do |validator|
        #         validator.validate(candidate_address)
        #       end
        #     end
        #
        #     email_validator.should accept_as_valid("person@company.com")
        def match_unless_raises(exception=Exception, &block)
          @expected_exception = exception
          match(&block)
        end

        # Customize the failure messsage to use when this matcher is invoked with
        # `should`. Only use this when the message generated by default doesn't
        # suit your needs.
        #
        # @example
        #
        #     RSpec::Matchers.define :have_strength do |expected|
        #       match { ... }
        #
        #       failure_message_for_should do |actual|
        #         "Expected strength of #{expected}, but had #{actual.strength}"
        #       end
        #     end
        #
        # @yield [Object] actual the actual object
        def failure_message_for_should(&block)
          cache_or_call_cached(:failure_message_for_should, &block)
        end

        # Customize the failure messsage to use when this matcher is invoked with
        # `should_not`. Only use this when the message generated by default
        # doesn't suit your needs.
        #
        # @example
        #
        #     RSpec::Matchers.define :have_strength do |expected|
        #       match { ... }
        #
        #       failure_message_for_should_not do |actual|
        #         "Expected not to have strength of #{expected}, but did"
        #       end
        #     end
        #
        # @yield [Object] actual the actual object
        # @yield [Object] actual the actual object
        def failure_message_for_should_not(&block)
          cache_or_call_cached(:failure_message_for_should_not, &block)
        end


        # Customize the description to use for one-liners.  Only use this when
        # the description generated by default doesn't suit your needs.
        #
        # @example
        #
        #     RSpec::Matchers.define :qualify_for do |expected|
        #       match { ... }
        #
        #       description do
        #         "qualify for #{expected}"
        #       end
        #     end
        def description(&block)
          cache_or_call_cached(:description, &block)
        end

        # Tells the matcher to diff the actual and expected values in the failure
        # message.
        def diffable
          @diffable = true
        end

        # Convenience for defining methods on this matcher to create a fluent
        # interface. The trick about fluent interfaces is that each method must
        # return self in order to chain methods together. `chain` handles that
        # for you.
        #
        # @example
        #
        #     RSpec::Matchers.define :have_errors_on do |key|
        #       chain :with do |message|
        #         @message = message
        #       end
        #
        #       match do |actual|
        #         actual.errors[key] == @message
        #       end
        #     end
        #
        #     minor.should have_errors_on(:age).with("Not old enough to participate")
        def chain(method, &block)
          define_method method do |*args|
            block.call(*args)
            self
          end
        end

        # @api private
        # Used internally by objects returns by +should+ and +should_not+.
        def diffable?
          @diffable
        end

        # @api private
        # Used internally by +should_not+
        def does_not_match?(actual)
          @actual = actual
          @match_for_should_not_block ?
            instance_eval_with_args(actual, &@match_for_should_not_block) :
            !matches?(actual)
        end

        def respond_to?(method, include_private=false)
          $matcher_execution_context != self && $matcher_execution_context.respond_to?(method, include_private) || super
        end

        private

        def method_missing(method, *args, &block)
          if $matcher_execution_context.respond_to?(method)
            $matcher_execution_context.send method, *args, &block
          else
            super(method, *args, &block)
          end
        end

        def include(*args)
          singleton_class.__send__(:include, *args)
        end

        def define_method(name, &block)
          singleton_class.__send__(:define_method, name, &block)
        end

        def making_declared_methods_public
          # Our home-grown instance_exec in ruby 1.8.6 results in any methods
          # declared in the block eval'd by instance_exec in the block to which we
          # are yielding here are scoped private. This is NOT the case for Ruby
          # 1.8.7 or 1.9.
          #
          # Also, due some crazy scoping that I don't understand, these methods
          # are actually available in the specs (something about the matcher being
          # defined in the scope of RSpec::Matchers or within an example), so not
          # doing the following will not cause specs to fail, but they *will*
          # cause features to fail and that will make users unhappy. So don't.
          orig_private_methods = private_methods
          yield
          (private_methods - orig_private_methods).each {|m| singleton_class.__send__ :public, m}
        end

        def cache_or_call_cached(key, &block)
          block ? cache(key, &block) : call_cached(key)
        end

        def cache(key, &block)
          @messages[key] = block
        end

        def call_cached(key)
          if @messages.has_key?(key)
            @messages[key].arity == 1 ? @messages[key].call(@actual) : @messages[key].call
          else
            send("default_#{key}")
          end
        end

        def default_description
          "#{name_to_sentence}#{expected_to_sentence}"
        end

        def default_failure_message_for_should
          "expected #{actual.inspect} to #{name_to_sentence}#{expected_to_sentence}"
        end

        def default_failure_message_for_should_not
          "expected #{actual.inspect} not to #{name_to_sentence}#{expected_to_sentence}"
        end

        unless method_defined?(:singleton_class)
          def singleton_class
            class << self; self; end
          end
        end
      end
    end
  end
end
