Feature: warn when expectation is set on nil

  Scenario: nil instance variable
    Given a file named "example_spec.rb" with:
      """
      RSpec.configure {|c| c.mock_with :rspec}
      describe "something" do
        it "does something" do
          @i_do_not_exist.should_receive(:foo)
          @i_do_not_exist.foo
        end
      end
      """
    When I run "rspec ./example_spec.rb"
    Then I should see "An expectation of :foo was set on nil"

  Scenario: allow
    Given a file named "example_spec.rb" with:
      """
      RSpec.configure {|c| c.mock_with :rspec}
      describe "something" do
        it "does something" do
          allow_message_expectations_on_nil
          nil.should_receive(:foo)
          nil.foo
        end
      end
      """
    When I run "rspec ./example_spec.rb"
    Then I should not see "An expectation"

  Scenario: allow in one example, but not on another
    Given a file named "example_spec.rb" with:
      """
      RSpec.configure {|c| c.mock_with :rspec}
      describe "something" do
        it "does something (foo)" do
          allow_message_expectations_on_nil
          nil.should_receive(:foo)
          nil.foo
        end
        it "does something (bar)" do
          nil.should_receive(:bar)
          nil.bar
        end
      end
      """
    When I run "rspec ./example_spec.rb"
    Then I should see "An expectation of :bar"
    And  I should not see "An expectation of :foo"
