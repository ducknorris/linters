require "scss_lint/violation"
require "scss_lint/system_call"

module ScssLint
  class Runner
    def initialize(config, system_call: SystemCall.new)
      @config_file = File.new(".scss-lint.yml", config.to_yaml)
      @system_call = system_call
    end

    def violations_for(file)
      violation_strings(file).map do |violation_string|
        Violation.new(violation_string).to_hash
      end
    end

    private

    attr_reader :config_file, :system_call

    def violation_strings(file)
      result = execute_linter(file).split("\n")
      result.select { |string| message_parsable?(string) }
    end

    def execute_linter(file)
      File.in_tmpdir(file, config_file) do |dir|
        run_linter_on_system(dir)
      end
    end

    def run_linter_on_system(directory)
      Dir.chdir(directory) do
        system_call.call("scss-lint")
      end
    rescue ScssLint::SystemCall::NonZeroExitStatusError => e
      e.output
    end

    def message_parsable?(string)
      ScssLint::Violation.parsable?(string)
    end
  end
end