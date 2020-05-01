RSpec.describe Yuriita::Query do
  describe "#keywords" do
    it "returns only keywords" do
      active = build(:expression, qualifier: "is", term: "active")
      author = build(:expression, qualifier: "author", term: "eebs")
      keyword = build(:keyword, value: "keyword")

      query = described_class.new(
        inputs: [active, keyword, author]
      )

      expect(query.keywords).to eq [keyword("keyword")]
    end
  end

  describe "#inputs" do
    it "returns all items" do
      active = build(:expression, qualifier: "is", term: "active")
      author = build(:expression, qualifier: "author", term: "eebs")

      query = described_class.new(
        inputs: [active, "keyword", author]
      )

      expect(query.inputs).to eq [active, "keyword", author]
    end
  end

  describe "#==" do
    it "is equal if the inputs are equal and in the same order" do
      active = build(:expression, qualifier: "is", term: "active")
      author = build(:expression, qualifier: "author", term: "eebs")

      query = described_class.new(inputs: [active, author])
      other = described_class.new(inputs: [active, author])

      expect(query).to eq other
    end

    it "is not equal if the inputs are equal but in a different order" do
      active = build(:expression, qualifier: "is", term: "active")
      author = build(:expression, qualifier: "author", term: "eebs")

      query = described_class.new(inputs: [author, active])
      other = described_class.new(inputs: [active, author])

      expect(query).not_to eq other
    end

    it "is not equal if the inputs are different" do
      active = build(:expression, qualifier: "is", term: "active")
      author = build(:expression, qualifier: "author", term: "eebs")

      query = described_class.new(inputs: [author, active])
      other = described_class.new(inputs: [author])

      expect(query).not_to eq other
    end

    it "is equal if both queries are empty" do
      query = described_class.new(inputs: [])
      other = described_class.new(inputs: [])

      expect(query).to eq other
    end
  end

  describe "#dup" do
    it "duplicates the inputs" do
      input = Yuriita::Inputs::Expression.new("is", "original")
      new_input = Yuriita::Inputs::Expression.new("is", "new")
      original = described_class.new(inputs: [input])

      duplicate = original.dup
      duplicate << new_input

      expect(duplicate.inputs).to include(input)
      expect(original.inputs).not_to include(new_input)
    end
  end

  describe "#clone" do
    it "duplicates the inputs" do
      input = Yuriita::Inputs::Expression.new("is", "original")
      new_input = Yuriita::Inputs::Expression.new("is", "new")
      original = described_class.new(inputs: [input])

      duplicate = original.clone
      duplicate << new_input

      expect(duplicate.inputs).to include(input)
      expect(original.inputs).not_to include(new_input)
    end
  end

  describe "#each" do
    it "yields the inputs" do
      published = build(:expression, qualifier: "is", term: "published")
      draft = build(:expression, qualifier: "is", term: "draft")
      query = described_class.new(inputs: [published, draft])

      expect do |b|
        query.each(&b)
      end.to yield_successive_args(published, draft)
    end
  end

  describe "#add_input" do
    it "adds an input to the query" do
      published = build(:expression, qualifier: "is", term: "published")
      query = described_class.new(inputs: [])

      query.add_input(published)

      expect(query).to include(published)
    end
  end

  describe "#delete" do
    it "removes an input from the query" do
      published = build(:expression, qualifier: "is", term: "published")
      draft = build(:expression, qualifier: "is", term: "draft")
      query = described_class.new(inputs: [published, draft])

      query.delete(published)

      expect(query).not_to include(published)
      expect(query).to include(draft)
    end
  end

  describe "#include?" do
    it "is true if the query contains the input" do
      published = build(:expression, qualifier: "is", term: "published")
      draft = build(:expression, qualifier: "is", term: "draft")

      query = described_class.new(inputs: [published, draft])

      expect(query).to include(published)
    end

    it "is false if the query does not contain the input" do
      published = build(:expression, qualifier: "is", term: "published")
      query = described_class.new(inputs: [])

      expect(query).not_to include(published)
    end
  end

  describe "#delete_if" do
    it "removes inputs matching the block" do
      published = build(:expression, qualifier: "is", term: "published")
      draft = build(:expression, qualifier: "is", term: "draft")
      query = described_class.new(inputs: [published, draft])

      query.delete_if { |input| input == published }

      expect(query).not_to include(published)
      expect(query).to include(draft)
    end
  end

  describe "#size" do
    it "returns the number of inputs" do
      published = build(:expression, qualifier: "is", term: "published")
      draft = build(:expression, qualifier: "is", term: "draft")

      query = described_class.new(inputs: [published, draft])

      expect(query.size).to eq 2
    end

    it "returns zero when there are no inputs" do
      query = described_class.new

      expect(query.size).to eq 0
    end
  end

  def keyword(value)
    Yuriita::Inputs::Keyword.new(value)
  end
end
