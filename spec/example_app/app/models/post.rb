class Post < ApplicationRecord
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates_presence_of :title, :body

  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }

  def self.search(field, term)
    sanitized_value = sanitize_sql_like(term)
    where("#{field} ILIKE :term", term: "%#{sanitized_value}%")
  end
end
