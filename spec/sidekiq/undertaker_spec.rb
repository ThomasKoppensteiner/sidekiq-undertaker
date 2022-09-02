# frozen_string_literal: true

require "spec_helper"

describe Sidekiq::Undertaker do
  describe ".max_error_msg_length" do
    around do |example|
      memo = described_class.max_error_msg_length
      example.run
      described_class.max_error_msg_length = memo
    end

    it "returns the default max_error_msg_length" do
      expect(described_class.max_error_msg_length).to eq(30)
    end

    it "updates the max_error_msg_length" do
      new_value = 99
      expect { described_class.max_error_msg_length = new_value }
        .to change(described_class, :max_error_msg_length)
        .from(30).to(new_value)

      expect(described_class.max_error_msg_length).to eq(new_value)
    end
  end
end
