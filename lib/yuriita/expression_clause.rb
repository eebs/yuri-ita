module Yuriita
  class ExpressionClause
    def initialize(filters:, combination:)
      @filters = filters
      @combination = combination
    end

    def apply(relation)
      return relation if filters.empty?

      relations = filters.map { |filter| filter.apply(relation) }

      combination.new(
        base_relation: relation,
        relations: relations,
      ).combine
    end

    private

    attr_reader :filters, :combination
  end
end
