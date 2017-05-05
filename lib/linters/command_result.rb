module Linters
  class CommandResult
    attr_reader :output

    def initialize(output:, status:)
      @output = output
      @status = status
    end

    def error?
      !status.success? && output_present?
    end

    private

    attr_reader :status

    def output_present?
      !output.nil? && !output.empty?
    end
  end
end
