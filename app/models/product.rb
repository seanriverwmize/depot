class Product < ApplicationRecord
  has_many :line_items
  before_destroy :ensure_not_referenced_by_line_items
  validates :title, :description, :image_url, presence: {message: 'is required'}
  validates :price, numericality: { greater_than_or_equal_to: 0.01, message: 'must be at least 0.01' }
  validates :title, uniqueness: { message: 'must be unique' }
  validates :title, length: {minimum: 10, maximum: 80, message: 'must be between 10 and 80 characters long.'}
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|png|jpg)\Z}i,
    message: 'Image must be a GIF, PNG, or JPG.'
  }

  private
  def ensure_not_referenced_by_line_items
    unless line_items.empty?
      errors.add(:base, 'Line Item(s) Present')
      throw :abort
    end
  end
end
