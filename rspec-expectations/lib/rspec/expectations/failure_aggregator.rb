module RSpec
  module Expectations
    # @private
    class FailureAggregator
      attr_reader :block_label, :metadata

      def aggregate
        RSpec::Support.with_failure_notifier(self) do
          begin
            yield
          rescue ExpectationNotMetError => e
            failures << e
          rescue Exception => e
            other_errors << e
          end
        end

        raise_aggregated_failures
      end

      def failures
        @failures ||= []
      end

      def other_errors
        @other_errors ||= []
      end

      # This method is defined to satisfy the callable interface
      # expected by `RSpec::Support.with_failure_notifier`.
      def call(failure)
        failure.set_backtrace(caller) unless failure.backtrace
        failures << failure
      end

    private

      def initialize(block_label, metadata)
        @block_label = block_label
        @metadata    = metadata
      end

      def raise_aggregated_failures
        all_errors = failures + other_errors

        case all_errors.size
        when 0 then return nil
        when 1 then raise all_errors.first
        else raise MultipleExpectationsNotMetError.new(self)
        end
      end
    end

    # Exception raised from `aggregate_failures` when multiple expectations fail.
    class MultipleExpectationsNotMetError
      # @return [String] The fully formatted exception message.
      def message
        @message ||= (["#{summary}:"] + enumerated_failures + enumerated_errors).join("\n\n")
      end

      # @return [Array<RSpec::Expectations::ExpectationNotMetError>] The list of expectation failures.
      def failures
        @failure_aggregator.failures
      end

      # @return [Array<Exception>] The list of other exceptions.
      def other_errors
        @failure_aggregator.other_errors
      end

      # @return [Array<Exception>] The list of expectation failures and other exceptions, combined.
      def all_exceptions
        failures + other_errors
      end

      # @return [String] The user-assigned label for the aggregation block.
      def aggregation_block_label
        @failure_aggregator.block_label
      end

      # @return [Hash] The metadata hash passed to `aggregate_failures`.
      def aggregation_metadata
        @failure_aggregator.metadata
      end

      # @return [String] A summary of the failure, including the block label and a count of failures.
      def summary
        "Got #{exception_count_description} from failure aggregation " \
        "block#{block_description}"
      end

      # return [String] A description of the failure/error counts.
      def exception_count_description
        failure_count = pluralize("failure", failures.size)
        return failure_count if other_errors.empty?
        error_count = pluralize("other error", other_errors.size)
        "#{failure_count} and #{error_count}"
      end

    private

      def initialize(failure_aggregator)
        @failure_aggregator = failure_aggregator
      end

      def block_description
        return "" unless aggregation_block_label
        " #{aggregation_block_label.inspect}"
      end

      def pluralize(noun, count)
        "#{count} #{noun}#{'s' unless count == 1}"
      end

      def enumerated(exceptions, index_offset)
        exceptions.each_with_index.map do |exception, index|
          index += index_offset
          formatted_message = yield exception
          "#{index_label index}#{indented formatted_message, index}"
        end
      end

      def enumerated_failures
        enumerated(failures, 0, &:message)
      end

      def enumerated_errors
        enumerated(other_errors, failures.size) do |error|
          "#{error.class}: #{error.message}"
        end
      end

      def indented(failure_message, index)
        line_1, *rest = failure_message.strip.lines.to_a
        first_line_indentation = ' ' * (longest_index_label_width - width_of_label(index))

        first_line_indentation + line_1 + rest.map do |line|
          line =~ /\S/ ? indentation + line : line
        end.join
      end

      def indentation
        @indentation ||= ' ' * longest_index_label_width
      end

      def longest_index_label_width
        @longest_index_label_width ||= width_of_label(failures.size)
      end

      def width_of_label(index)
        index_label(index).chars.count
      end

      def index_label(index)
        "  #{index + 1}) "
      end
    end
  end
end
