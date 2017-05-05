require "open3"
require "linters/command_result"

module Linters
  class SystemCall
    def initialize(command:, directory:)
      @command = command
      @directory = directory
    end

    def execute
      output, status = Open3.capture2e(command, chdir: directory)
      CommandResult.new(output: output, status: status)
    end

    private

    attr_reader :command, :directory
  end
end
