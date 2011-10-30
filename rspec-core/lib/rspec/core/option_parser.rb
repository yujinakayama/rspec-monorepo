# http://www.ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParser.html
require 'optparse'

module RSpec::Core
  class Parser
    def self.parse!(args)
      new.parse!(args)
    end

    class << self
      alias_method :parse, :parse!
    end

    def parse!(args)
      return {} if args.empty?
      if args.include?("--formatter")
        RSpec.deprecate("the --formatter option", "-f or --format")
        args[args.index("--formatter")] = "--format"
      end
      options = {}
      parser(options).parse!(args)
      options
    end

    alias_method :parse, :parse!

    def parser(options)
      OptionParser.new do |parser|
        parser.banner = "Usage: rspec [options] [files or directories]\n\n"

        parser.on('-b', '--backtrace', 'Enable full backtrace') do |o|
          options[:full_backtrace] = true
        end

        parser.on('-c', '--[no-]color', '--[no-]colour', 'Enable color in the output') do |o|
          options[:color_enabled] = o
        end

        parser.on('-d', '--debugger', 'Enable debugging') do |o|
          options[:debug] = true
        end

        parser.on('-e', '--example STRING', "Run examples whose full nested names include STRING") do |o|
          options[:full_description] = Regexp.compile(Regexp.escape(o))
        end

        parser.on('-f', '--format FORMATTER', 'Choose a formatter',
                '  [p]rogress (default - dots)',
                '  [d]ocumentation (group and example names)',
                '  [h]tml',
                '  [t]extmate',
                '  custom formatter class name') do |o|
          options[:formatters] ||= []
          options[:formatters] << [o]
        end

        parser.on('-o', '--out FILE',
                  'Write output to a file instead of STDOUT. This option applies',
                  'to the previously specified --format, or the default format if',
                  'no format is specified.'
                 ) do |o|
          options[:formatters] ||= [['progress']]
          options[:formatters].last << o
        end

        parser.on_tail('-h', '--help', "You're looking at it.") do
          puts parser
          exit
        end

        parser.on('-I DIRECTORY', 'specify $LOAD_PATH directory (may be used more than once)') do |dir|
          options[:libs] ||= []
          options[:libs] << dir
        end

        parser.on('-l', '--line_number LINE', 'Specify the line number of an example to run.  May be specified multiple times.') do |o|
          (options[:line_numbers] ||= []) << o
        end

        parser.on('-O', '--options PATH', 'Specify the path to an options file') do |path|
          options[:custom_options_file] = path
        end
        
        parser.on('--order TYPE', 'Run examples by the specified order type',
                  '  [rand] randomized',
                  '  [random] alias for rand',
                  '  [random:SEED] e.g. --order random:123') do |o|
          options[:order] = o
        end

        parser.on('--seed SEED', "Equivalent of --order rand:SEED") do |seed|
          options[:order] = "rand:#{seed}"
        end

        parser.on('-p', '--profile', 'Enable profiling of examples with output of the top 10 slowest examples') do |o|
          options[:profile_examples] = o
        end

        parser.on('-P', '--pattern PATTERN', 'Load files matching this pattern. Default is "spec/**/*_spec.rb"') do |o|
          options[:pattern] = o
        end

        parser.on('-r', '--require PATH', 'Require a file') do |path|
          options[:requires] ||= []
          options[:requires] << path
        end

        parser.on('-v', '--version', 'Show version') do
          puts RSpec::Core::Version::STRING
          exit
        end

        parser.on('-X', '--[no-]drb', 'Run examples via DRb') do |o|
          options[:drb] = o
        end

        parser.on('--configure COMMAND', 'Generate configuration files') do |cmd|
          CommandLineConfiguration.new(cmd).run
          exit
        end

        parser.on('--drb-port [PORT]', 'Port to connect to on the DRb server') do |o|
          options[:drb_port] = o.to_i
        end

        parser.on('--fail-fast', 'Abort the run on first failure.') do |o|
          options[:fail_fast] = true
        end

        parser.on('--failure-exit-code CODE', 'Override the exit code used when there are failing specs.') do |o|
          options[:failure_exit_code] = o.to_i
        end

        parser.on('-t', '--tag TAG[:VALUE]', 'Run examples with the specified tag',
                'To exclude examples, add ~ before the tag (e.g. ~slow)',
                '(TAG is always converted to a symbol)') do |tag|
          filter_type = tag =~ /^~/ ? :exclusion_filter : :inclusion_filter

          name,value = tag.gsub(/^(~@|~|@)/, '').split(':')
          name = name.to_sym

          options[filter_type] ||= {}
          options[filter_type][name] = case value
                                       when /^(true|false|nil)$/
                                         eval(value)
                                       when nil
                                         true
                                       else
                                         value
                                       end
        end

        parser.on('--tty', 'Used internally by rspec when sending commands to other processes') do |o|
          options[:tty] = true
        end

        parser.on('--default_path PATH', 'Set the default path where RSpec looks for examples.',
                                         'Can be a path to a file or a directory') do |path|
          options[:default_path] = path
        end
      end
    end
  end
end
