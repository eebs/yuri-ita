module Yuriita
  class KeywordFilter
    def initialize(matcher:, combination:, &block)
      @matcher = matcher
      @combination = combination
      @block = block
    end

    def apply(keywords, scopes)
      if matches?(scopes)
        clauses = build_clauses(keywords)
        [Clauses::Merge.new(clauses: clauses, combination: combination)]
      else
        []
      end
    end

    private

    attr_reader :matcher, :combination, :block

    def matches?(scopes)
      if scopes.empty?
        true
      else
        scopes.any? do |scope|
          matcher.match?(scope)
        end
      end
    end

    def build_clauses(keywords)
      keywords.map do |keyword|
        Clauses::Where.new(block.call(keyword))
      end
    end
  end
end
