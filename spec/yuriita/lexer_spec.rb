require 'spec_helper'
require 'yuriita/lexer'

RSpec.describe Yuriita::Lexer do
  describe ".lex" do
    it "recognizes colon separated words" do
      expect("is:active").to produce_tokens(
        [
          "WORD(is)",
          "COLON",
          "WORD(active)",
          "EOS",
        ]
      )
    end

    it "recognizes bare words" do
      expect("first last").to produce_tokens(
        [
          "WORD(first)",
          "SPACE",
          "WORD(last)",
          "EOS",
        ]
      )
    end

    it "recognizes words with underscores" do
      expect("created_by:eebs").to produce_tokens(
        [
          "WORD(created_by)",
          "COLON",
          "WORD(eebs)",
          "EOS",
        ]
      )
    end

    it "recognizes quoted words" do
      expect("\"quoted words\"").to produce_tokens(
        [
          "QUOTE",
          "WORD(quoted)",
          "SPACE",
          "WORD(words)",
          "QUOTE",
          "EOS",
        ]
      )
    end

    it "recognizes negation" do
      expect("-word").to produce_tokens(
        [
          "NEGATION",
          "WORD(word)",
          "EOS",
        ]
      )
    end

    it "recognizes 'in'" do
      expect("in:body").to produce_tokens(
        [
          "IN",
          "COLON",
          "WORD(body)",
          "EOS",
        ]
      )
    end

    it "does not recognize 'in' within other words" do
      expect("interrupt:gum").to produce_tokens(
        [
          "WORD(interrupt)",
          "COLON",
          "WORD(gum)",
          "EOS",
        ]
      )
    end
  end
end
