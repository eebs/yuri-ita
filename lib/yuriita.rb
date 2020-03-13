require "yuriita/version"
require "yuriita/sift"

require "yuriita/query"
require "yuriita/query/definition"

require "yuriita/or_combination"
require "yuriita/and_combination"

require "yuriita/expression_filter"
require "yuriita/keyword_filter"
require "yuriita/sorter"

require "yuriita/clauses/where"
require "yuriita/clauses/where_not"
require "yuriita/clauses/order"

module Yuriita
  class Error < StandardError; end

  extend Sift
end
