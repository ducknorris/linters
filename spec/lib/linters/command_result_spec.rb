require "linters/command_result"

describe Linters::CommandResult do
  describe "#error?" do
    context "when there is some output" do
      context "when return code is success" do
        it "returns false" do
          status = instance_double("Process::Status", success?: true)
          comand_result = described_class.new(output: "foo", status: status)

          expect(comand_result).not_to be_error
        end
      end

      context "when return code is not success" do
        it "returns true" do
          status = instance_double("Process::Status", success?: false)
          comand_result = described_class.new(output: "foo", status: status)

          expect(comand_result).to be_error
        end
      end
    end

    context "when output is blank" do
      context "when return code is success" do
        it "returns false" do
          status = instance_double("Process::Status", success?: true)
          comand_result = described_class.new(output: "", status: status)

          expect(comand_result).not_to be_error
        end
      end

      context "when return code is not success" do
        it "returns false" do
          status = instance_double("Process::Status", success?: false)
          comand_result = described_class.new(output: "", status: status)

          expect(comand_result).not_to be_error
        end
      end
    end
  end
end
