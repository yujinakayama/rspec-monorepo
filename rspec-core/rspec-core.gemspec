# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-core}
  s.version = "2.0.0.a2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Chelimsky", "Chad Humphries"]
  s.date = %q{2010-01-29}
  s.default_executable = %q{rspec}
  s.description = %q{Rspec runner and example group classes}
  s.email = %q{dchelimsky@gmail.com;chad.humphries@gmail.com}
  s.executables = ["rspec"]
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     ".treasure_map.rb",
     "License.txt",
     "README.markdown",
     "Rakefile",
     "TODO.markdown",
     "bin/rspec",
     "cucumber.yml",
     "example_specs/failing/README.txt",
     "example_specs/failing/diffing_spec.rb",
     "example_specs/failing/failing_implicit_docstrings_example.rb",
     "example_specs/failing/failure_in_after.rb",
     "example_specs/failing/failure_in_before.rb",
     "example_specs/failing/mocking_example.rb",
     "example_specs/failing/mocking_with_flexmock.rb",
     "example_specs/failing/mocking_with_mocha.rb",
     "example_specs/failing/mocking_with_rr.rb",
     "example_specs/failing/partial_mock_example.rb",
     "example_specs/failing/pending_example.rb",
     "example_specs/failing/predicate_example.rb",
     "example_specs/failing/raising_example.rb",
     "example_specs/failing/spec_helper.rb",
     "example_specs/failing/syntax_error_example.rb",
     "example_specs/failing/team_spec.rb",
     "example_specs/failing/timeout_behaviour.rb",
     "example_specs/passing/custom_formatter.rb",
     "example_specs/passing/custom_matchers.rb",
     "example_specs/passing/dynamic_spec.rb",
     "example_specs/passing/file_accessor.rb",
     "example_specs/passing/file_accessor_spec.rb",
     "example_specs/passing/filtered_formatter.rb",
     "example_specs/passing/filtered_formatter_example.rb",
     "example_specs/passing/greeter_spec.rb",
     "example_specs/passing/helper_method_example.rb",
     "example_specs/passing/implicit_docstrings_example.rb",
     "example_specs/passing/io_processor.rb",
     "example_specs/passing/io_processor_spec.rb",
     "example_specs/passing/mocking_example.rb",
     "example_specs/passing/multi_threaded_example_group_runner.rb",
     "example_specs/passing/nested_classes_example.rb",
     "example_specs/passing/options_example.rb",
     "example_specs/passing/options_formatter.rb",
     "example_specs/passing/partial_mock_example.rb",
     "example_specs/passing/pending_example.rb",
     "example_specs/passing/predicate_example.rb",
     "example_specs/passing/shared_example_group_example.rb",
     "example_specs/passing/shared_stack_examples.rb",
     "example_specs/passing/simple_matcher_example.rb",
     "example_specs/passing/spec_helper.rb",
     "example_specs/passing/stack.rb",
     "example_specs/passing/stack_spec.rb",
     "example_specs/passing/stack_spec_with_nested_example_groups.rb",
     "example_specs/passing/stubbing_example.rb",
     "example_specs/passing/yielding_example.rb",
     "example_specs/ruby1.9.compatibility/access_to_constants_spec.rb",
     "features-pending/example_groups/example_group_with_should_methods.feature",
     "features-pending/example_groups/implicit_docstrings.feature",
     "features-pending/expectations/expect_change.feature",
     "features-pending/expectations/expect_error.feature",
     "features-pending/extensions/custom_example_group.feature",
     "features-pending/formatters/custom_formatter.feature",
     "features-pending/heckle/heckle.feature",
     "features-pending/interop/examples_and_tests_together.feature",
     "features-pending/interop/rspec_output.feature",
     "features-pending/interop/test_but_not_test_unit.feature",
     "features-pending/interop/test_case_with_should_methods.feature",
     "features-pending/matchers/define_diffable_matcher.feature",
     "features-pending/matchers/define_matcher_with_fluent_interface.feature",
     "features-pending/mocks/stub_implementation.feature",
     "features-pending/pending/pending_examples.feature",
     "features-pending/runner/specify_line_number.feature",
     "features/before_and_after_blocks/around.feature",
     "features/before_and_after_blocks/before_and_after_blocks.feature",
     "features/command_line/line_number_appended_to_path.feature",
     "features/command_line/line_number_option.feature",
     "features/example_groups/describe_aliases.feature",
     "features/example_groups/nested_groups.feature",
     "features/expectations/customized_message.feature",
     "features/matchers/define_matcher.feature",
     "features/matchers/define_matcher_outside_rspec.feature",
     "features/mock_framework_integration/use_flexmock.feature",
     "features/mock_framework_integration/use_mocha.feature",
     "features/mock_framework_integration/use_rr.feature",
     "features/mock_framework_integration/use_rspec.feature",
     "features/mocks/block_local_expectations.feature",
     "features/mocks/mix_stubs_and_mocks.feature",
     "features/step_definitions/running_rspec_steps.rb",
     "features/subject/explicit_subject.feature",
     "features/subject/implicit_subject.feature",
     "features/support/env.rb",
     "features/support/matchers/smart_match.rb",
     "lib/rspec/autorun.rb",
     "lib/rspec/core.rb",
     "lib/rspec/core/advice.rb",
     "lib/rspec/core/backward_compatibility.rb",
     "lib/rspec/core/command_line_options.rb",
     "lib/rspec/core/configuration.rb",
     "lib/rspec/core/deprecation.rb",
     "lib/rspec/core/example.rb",
     "lib/rspec/core/example_group.rb",
     "lib/rspec/core/example_group_subject.rb",
     "lib/rspec/core/formatters.rb",
     "lib/rspec/core/formatters/base_formatter.rb",
     "lib/rspec/core/formatters/base_text_formatter.rb",
     "lib/rspec/core/formatters/documentation_formatter.rb",
     "lib/rspec/core/formatters/progress_formatter.rb",
     "lib/rspec/core/kernel_extensions.rb",
     "lib/rspec/core/load_path.rb",
     "lib/rspec/core/metadata.rb",
     "lib/rspec/core/mocking/with_absolutely_nothing.rb",
     "lib/rspec/core/mocking/with_flexmock.rb",
     "lib/rspec/core/mocking/with_mocha.rb",
     "lib/rspec/core/mocking/with_rr.rb",
     "lib/rspec/core/mocking/with_rspec.rb",
     "lib/rspec/core/rake_task.rb",
     "lib/rspec/core/ruby_project.rb",
     "lib/rspec/core/runner.rb",
     "lib/rspec/core/shared_behaviour.rb",
     "lib/rspec/core/shared_behaviour_kernel_extensions.rb",
     "lib/rspec/core/version.rb",
     "lib/rspec/core/world.rb",
     "rspec-core.gemspec",
     "script/console",
     "spec/resources/example_classes.rb",
     "spec/rspec/core/command_line_options_spec.rb",
     "spec/rspec/core/configuration_spec.rb",
     "spec/rspec/core/example_group_spec.rb",
     "spec/rspec/core/example_group_subject_spec.rb",
     "spec/rspec/core/example_spec.rb",
     "spec/rspec/core/formatters/base_formatter_spec.rb",
     "spec/rspec/core/formatters/documentation_formatter_spec.rb",
     "spec/rspec/core/formatters/progress_formatter_spec.rb",
     "spec/rspec/core/kernel_extensions_spec.rb",
     "spec/rspec/core/metadata_spec.rb",
     "spec/rspec/core/mocha_spec.rb",
     "spec/rspec/core/resources/a_bar.rb",
     "spec/rspec/core/resources/a_foo.rb",
     "spec/rspec/core/resources/a_spec.rb",
     "spec/rspec/core/resources/custom_example_group_runner.rb",
     "spec/rspec/core/resources/example_classes.rb",
     "spec/rspec/core/resources/utf8_encoded.rb",
     "spec/rspec/core/ruby_project_spec.rb",
     "spec/rspec/core/runner_spec.rb",
     "spec/rspec/core/shared_behaviour_spec.rb",
     "spec/rspec/core/world_spec.rb",
     "spec/rspec/core_spec.rb",
     "spec/ruby_forker.rb",
     "spec/spec_helper.rb",
     "specs.watchr"
  ]
  s.homepage = %q{http://github.com/rspec/core}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rspec}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{rspec-core 2.0.0.a2}
  s.test_files = [
    "spec/resources/example_classes.rb",
     "spec/rspec/core/command_line_options_spec.rb",
     "spec/rspec/core/configuration_spec.rb",
     "spec/rspec/core/example_group_spec.rb",
     "spec/rspec/core/example_group_subject_spec.rb",
     "spec/rspec/core/example_spec.rb",
     "spec/rspec/core/formatters/base_formatter_spec.rb",
     "spec/rspec/core/formatters/documentation_formatter_spec.rb",
     "spec/rspec/core/formatters/progress_formatter_spec.rb",
     "spec/rspec/core/kernel_extensions_spec.rb",
     "spec/rspec/core/metadata_spec.rb",
     "spec/rspec/core/mocha_spec.rb",
     "spec/rspec/core/resources/a_bar.rb",
     "spec/rspec/core/resources/a_foo.rb",
     "spec/rspec/core/resources/a_spec.rb",
     "spec/rspec/core/resources/custom_example_group_runner.rb",
     "spec/rspec/core/resources/example_classes.rb",
     "spec/rspec/core/resources/utf8_encoded.rb",
     "spec/rspec/core/ruby_project_spec.rb",
     "spec/rspec/core/runner_spec.rb",
     "spec/rspec/core/shared_behaviour_spec.rb",
     "spec/rspec/core/world_spec.rb",
     "spec/rspec/core_spec.rb",
     "spec/ruby_forker.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec-expectations>, [">= 2.0.0.a2"])
      s.add_development_dependency(%q<rspec-mocks>, [">= 2.0.0.a2"])
      s.add_development_dependency(%q<cucumber>, [">= 0.5.3"])
    else
      s.add_dependency(%q<rspec-expectations>, [">= 2.0.0.a2"])
      s.add_dependency(%q<rspec-mocks>, [">= 2.0.0.a2"])
      s.add_dependency(%q<cucumber>, [">= 0.5.3"])
    end
  else
    s.add_dependency(%q<rspec-expectations>, [">= 2.0.0.a2"])
    s.add_dependency(%q<rspec-mocks>, [">= 2.0.0.a2"])
    s.add_dependency(%q<cucumber>, [">= 0.5.3"])
  end
end

