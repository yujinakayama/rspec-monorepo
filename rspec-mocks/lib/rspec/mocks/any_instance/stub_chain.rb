module RSpec
  module Mocks
    module AnyInstance
      # @private
      class StubChain < Chain

        # @private
        def expectation_fulfilled?
          true
        end

        private

        def create_message_expectation_on(instance)
          proxy = ::RSpec::Mocks.proxy_for(instance)
          expected_from = IGNORED_BACKTRACE_LINE
          stub = proxy.add_stub(expected_from, *@expectation_args, &@expectation_block)

          warn_about_receiver_passing_if_necessary

          if RSpec::Mocks.configuration.yield_receiver_to_any_instance_implementation_blocks?
            stub.and_yield_receiver_to_implementation
          end

          stub
        end

        def invocation_order
          @invocation_order ||= {
            :with => [nil],
            :and_return => [:with, nil],
            :and_raise => [:with, nil],
            :and_yield => [:with, nil],
            :and_call_original => [:with, nil]
          }
        end

        def verify_invocation_order(rspec_method_name, *args, &block)
          unless invocation_order[rspec_method_name].include?(last_message)
            raise(NoMethodError, "Undefined method #{rspec_method_name}")
          end
        end

        def warn_about_receiver_passing_if_necessary
          Kernel.warn(<<MSG
`allow_any_instance_of(...).to receive(:message) { ... }` blocks will get the
receiving instance in 3.0. please explicitly set:
`RSpec::Mocks.configuration.yield_receiver_to_any_instance_implementation_blocks = true`
in your spec helper and fix any failing specs.
MSG
          ) if RSpec::Mocks.configuration.should_warn_about_any_instance_blocks?
        end
      end
    end
  end
end
