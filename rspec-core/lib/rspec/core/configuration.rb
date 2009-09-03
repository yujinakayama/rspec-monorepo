module Rspec
  module Core
    class Configuration
      # Regex patterns to scrub backtrace with
      attr_reader :backtrace_clean_patterns
      
      # All of the defined before/after blocks setup in the configuration
      attr_reader :before_and_afters

      # Allows you to control what examples are ran by filtering 
      attr_reader :filter

      attr_reader :exclusion_filter

      # Modules that will be included or extended based on given filters
      attr_reader :include_or_extend_modules

      # Run all examples if the run is filtered, and no examples were found.  Normally this is what you want -
      # when using focused examples for instance.  Defaults to true
      attr_accessor :run_all_when_everything_filtered

      # Enable verbose interal logging of the framework - defaults to false
      attr_accessor :trace

      attr_reader :options

      def initialize
        @run_all_when_everything_filtered = true
        @before_and_afters = { :before => { :each => [], :all => [] }, :after => { :each => [], :all => [] } }
        @include_or_extend_modules = []
        @filter, @exclusion_filter = nil, nil
        @options = default_options
        @backtrace_clean_patterns = []
      end
      
      def default_options
        {
          :color_enabled => false,
          :mock_framework => nil,
          :profile_examples => false,
          :files_to_run => [],
          :filename_pattern => '**/*_spec.rb',
          :formatter_class => Rspec::Core::Formatters::ProgressFormatter,
          :backtrace_clean_patterns => [/\/lib\/ruby\//, 
                                        /bin\/rcov:/, 
                                        /vendor\/rails/, 
                                        /bin\/rspec/, 
                                        /bin\/spec/,
                                        /lib\/rspec\/core/,
                                        /lib\/rspec\/expectations/,
                                        /lib\/rspec\/mocks/]
        }
      end
      
      def cleaned_from_backtrace?(line)
        options[:backtrace_clean_patterns].any? { |regex| line =~ regex }
      end
      
      def mock_framework=(use_me_to_mock)
        options[:mock_framework] = use_me_to_mock
        
        mock_framework_class = case use_me_to_mock.to_s
        when /rspec/i
          require 'rspec/core/mocking/with_rspec'
          Rspec::Core::Mocking::WithRspec
        when /mocha/i
          require 'rspec/core/mocking/with_mocha'
          Rspec::Core::Mocking::WithMocha
        when /rr/i
          require 'rspec/core/mocking/with_rr'
          Rspec::Core::Mocking::WithRR
        when /flexmock/i
          require 'rspec/core/mocking/with_flexmock'
          Rspec::Core::Mocking::WithFlexmock
        else
          require 'rspec/core/mocking/with_absolutely_nothing'
          Rspec::Core::Mocking::WithAbsolutelyNothing
        end 
        
        options[:mock_framework_class] = mock_framework_class
        Rspec::Core::ExampleGroup.send(:include, mock_framework_class)
      end
      
      def mock_framework
        options[:mock_framework]
      end

      def filename_pattern
        options[:filename_pattern]
      end

      def filename_pattern=(new_pattern)
        options[:filename_pattern] = new_pattern
      end 

      def color_enabled=(on_or_off)
        options[:color_enabled] = on_or_off
      end

      def color_enabled?
        options[:color_enabled]
      end
      
      # Enable profiling of example run - defaults to false
      def profile_examples
        options[:profile_examples]
      end
      
      def profile_examples=(profile)
        options[:profile_examples] = on_or_off
      end
     
      def formatter_class
        options[:formatter_class]
      end
     
      def formatter=(formatter_to_use)
        formatter_class = case formatter_to_use.to_s
        when 'documentation' 
          Rspec::Core::Formatters::DocumentationFormatter
        when 'progress' 
          Rspec::Core::Formatters::ProgressFormatter
        else 
          raise ArgumentError, "Formatter '#{formatter_to_use}' unknown - maybe you meant 'documentation' or 'progress'?."
        end
        options[:formatter_class] = formatter_class
      end
        
      def formatter
        @formatter ||= formatter_class.new
      end
      
      def files_to_run
        options[:files_to_run]
      end
      
      def files_to_run=(*files)
        files.flatten!

        result = []
        files.each do |file|
          if File.directory?(file)
            filename_pattern.split(",").each do |pattern|
              result += Dir[File.expand_path("#{file}/#{pattern.strip}")]
            end
          elsif File.file?(file)
            result << file
          else
            raise "File or directory not found: #{file}"
          end
        end

        options[:files_to_run] = result
      end

      # E.g. alias_example_to :crazy_slow, :speed => 'crazy_slow' defines
      # crazy_slow as an example variant that has the crazy_slow speed option
      def alias_example_to(new_name, extra_options={})
        Rspec::Core::ExampleGroup.alias_example_to(new_name, extra_options)
      end

      def autorun!
        Rspec::Core::Runner.autorun
      end

      def filter_run(options={})
        @filter = options
      end

      def run_all_when_everything_filtered?
        @run_all_when_everything_filtered
      end

      # Where does output go? For now $stdout
      def output
        $stdout
      end

      def puts(msg='')
        output.puts(msg)    
      end

      def parse_command_line_args(args)
        @command_line_options = Rspec::Core::CommandLineOptions.parse(args)
      end

      def include(mod, options={})
        include_or_extend_modules << [:include, mod, options]
      end

      def extend(mod, options={})
        include_or_extend_modules << [:extend, mod, options]
      end

      def find_modules(group)
        include_or_extend_modules.select do |include_or_extend, mod, options|
          options.all? do |filter_on, filter|
            Rspec::Core.world.apply_condition(filter_on, filter, group.metadata)
          end
        end
      end

      def before(each_or_all=:each, options={}, &block)
        before_and_afters[:before][each_or_all] << [options, block]
      end

      def after(each_or_all=:each, options={}, &block)
        before_and_afters[:after][each_or_all] << [options, block]
      end

      def find_before_or_after(desired_before_or_after, desired_each_or_all, group)
        before_and_afters[desired_before_or_after][desired_each_or_all].select do |options, block|
          options.all? do |filter_on, filter|
            Rspec::Core.world.apply_condition(filter_on, filter, group.metadata)
          end
        end.map { |options, block| block }
      end

    end

  end
end
