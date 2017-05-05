require "resque"
require "linters/runner"
require "linters/rubocop/options"

describe Linters::Runner do
  describe "#call" do
    context "when linter encounters an error" do
      it "enqueues a job with an error" do
        config = <<~EOS
          Style/StringLiterals:
          Enabled: true
        EOS
        attributes = {
          "commit_sha" => "foobar",
          "config" => config,
          "content" => "puts 'hello world'",
          "filename" => "foo.rb",
          "linter_name" => "rubocop",
          "patch" => "",
          "pull_request_number" => "123",
        }
        allow(Resque).to receive(:enqueue)

        described_class.call(
          linter_options: Linters::Rubocop::Options.new,
          attributes: attributes,
        )

        expect(Resque).to have_received(:enqueue).with(
          CompletedFileReviewJob,
          commit_sha: attributes["commit_sha"],
          filename: attributes["filename"],
          linter_name: attributes["linter_name"],
          patch: attributes["patch"],
          pull_request_number: attributes["pull_request_number"],
          violations: [],
          error: a_string_including("Warning: unrecognized cop Enabled found"),
        )
      end
    end
  end
end
