require "spec_helper"
require "linters/system_call"

describe Linters::SystemCall do
  context "running valid command" do
    it "captures stdout" do
      system = Linters::SystemCall.new(
        command: "printf 'Hello World!'",
        directory: ".",
      )

      result = system.execute

      expect(result).to have_attributes(
        output: "Hello World!",
        error?: false,
      )
    end

    it "captures stderr" do
      system = Linters::SystemCall.new(
        command: "printf 'Hello World!' 1>&2",
        directory: ".",
      )

      result = system.execute

      expect(result).to have_attributes(
        output: "Hello World!",
        error?: false,
      )
    end

    it "captures and concats stdout and stderr" do
      system = Linters::SystemCall.new(
        command: "printf 'Hello Stdout!' && printf 'Hello Stderr!' 1>&2",
        directory: ".",
      )

      result = system.execute

      expect(result).to have_attributes(
        output: "Hello Stdout!Hello Stderr!",
        error?: false,
      )
    end
  end

  context "when running an invalid command" do
    it "returns an result with the error output" do
      system = Linters::SystemCall.new(
        command: "ruby invalid",
        directory: ".",
      )

      result = system.execute

      expect(result).to have_attributes(
        output: "ruby: No such file or directory -- invalid (LoadError)\n",
        error?: true,
      )
    end
  end
end
