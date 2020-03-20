require "spec_helper"
require "yuriita/parser"

RSpec.describe Yuriita::Parser do
  describe '#parse' do
    it "parses an empty string" do
      query = parse(tokens([:EOS]))

      expect(query.keywords).to eq []
      expect(query.inputs).to eq []
    end

    it "parses keywords" do
      query = parse(tokens([:WORD, "hello"], [:EOS]))

      expect(query.keywords).to eq ["hello"]
    end

    it "parses a keyword with an expression_input" do
      query = parse(tokens(
        [:WORD, "hello"],
        [:SPACE],
        [:WORD, "label"], [:COLON], [:WORD, "bug"],
        [:EOS],
      ))

      expect(query.keywords).to eq ["hello"]
      expect(query.inputs).to contain_exactly(
        an_input_matching("label", "bug")
      )
    end

    it "parses keywords with an expression_input between them" do
      query = parse(tokens(
        [:WORD, "hello"],
        [:SPACE],
        [:WORD, "label"], [:COLON], [:WORD, "bug"],
        [:SPACE],
        [:WORD, "world"],
        [:EOS],
      ))

      expect(query.keywords).to eq ["hello", "world"]
      expect(query.inputs).to contain_exactly(
        an_input_matching("label", "bug")
      )
    end

    it "parses interspersed keywords and expression inputs" do
      query = parse(tokens(
        [:WORD, "hello"],
        [:SPACE],
        [:WORD, "label"], [:COLON], [:WORD, "bug"],
        [:SPACE],
        [:WORD, "world"],
        [:SPACE],
        [:WORD, "label"], [:COLON], [:WORD, "security"],
        [:EOS],
      ))


      expect(query.keywords).to eq ["hello", "world"]
      expect(query.inputs).to contain_exactly(
        an_input_matching("label", "bug"),
        an_input_matching("label", "security")
      )
    end

    it "parses a complex mix of keywords and expression inputs" do
      query = parse(tokens(
        [:WORD, "hello"],
        [:SPACE],
        [:WORD, "world"],
        [:SPACE],
        [:WORD, "label"], [:COLON], [:WORD, "red"],
        [:SPACE],
        [:WORD, "label"], [:COLON], [:WORD, "blue"],
        [:SPACE],
        [:WORD, "search"],
        [:SPACE],
        [:WORD, "label"], [:COLON], [:WORD, "green"],
        [:SPACE],
        [:WORD, "term"],
        [:EOS],
      ))

      expect(query.keywords).to eq ["hello", "world", "search", "term"]
      expect(query.inputs).to contain_exactly(
        an_input_matching("label", "red"),
        an_input_matching("label", "blue"),
        an_input_matching("label", "green"),
      )
    end

    it "parses an expression input" do
      query = parse(tokens([:WORD, "is"], [:COLON], [:WORD, "active"], [:EOS]))

      expect(query.inputs).to contain_exactly(
        an_input_matching("is", "active"),
      )
    end

    it "parses an expression input with a quoted word" do
      query = parse(tokens(
        [:WORD, "label"], [:COLON], [:QUOTE], [:WORD, "bug"], [:QUOTE], [:EOS],
      ))

      expect(query.inputs).to contain_exactly(
        an_input_matching("label", "bug"),
      )
    end

    it "parses an expression input with a quoted phrase" do
      query = parse(tokens(
        [:WORD, "label"], [:COLON], [:QUOTE], [:WORD, "bug"], [:SPACE],
        [:WORD, "report"], [:QUOTE], [:EOS],
      ))

      expect(query.inputs).to contain_exactly(
        an_input_matching("label", "bug report"),
      )
    end

    it "parses an expression input with a quoted phrase containing extra spaces" do
      query = parse(tokens(
        [:WORD, "label"], [:COLON],
        [:QUOTE],
        [:SPACE], [:WORD, "bug"], [:SPACE], [:WORD, "report"], [:SPACE],
        [:QUOTE], [:EOS],
      ))

      expect(query.inputs).to contain_exactly(
        an_input_matching("label", "bug report"),
      )
    end

    it "parses a list of expression inputs" do
      query = parse(tokens(
        [:WORD, "label"], [:COLON], [:WORD, "bug"], [:SPACE],
        [:WORD, "label"], [:COLON], [:WORD, "security"], [:SPACE],
        [:WORD, "author"], [:COLON], [:WORD, "eebs"], [:EOS],
      ))

      expect(query.inputs).to contain_exactly(
        an_input_matching("label", "bug"),
        an_input_matching("label", "security"),
        an_input_matching("author", "eebs"),
      )
    end

    it "parses a sort input" do
      query = parse(tokens(
        [:SORT], [:COLON], [:WORD, "title"], [:EOS],
      ))
      expect(query.inputs).to contain_exactly(
        an_input_matching("sort", "title")
      )
    end

    it "parses a scope input" do
      query = parse(tokens(
        [:IN], [:COLON], [:WORD, "title"], [:EOS],
      ))

      expect(query.inputs).to contain_exactly(
        an_input_matching("in", "title")
      )
    end

    it "parses a scope_input with keywords" do
      query = parse(tokens(
        [:WORD, "awesome"],
        [:SPACE],
        [:IN],
        [:COLON],
        [:WORD, "title"],
        [:SPACE],
        [:WORD, "ideas"],
        [:EOS],
      ))

      expect(query.keywords).to eq ["awesome", "ideas"]
      expect(query.inputs).to contain_exactly(
        an_input_matching("in", "title")
      )
    end
  end

  def parse(tokens)
    described_class.new.parse(tokens)
  end
end
