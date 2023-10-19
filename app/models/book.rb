class Book < ApplicationRecord
  belongs_to :user

  validates :title, uniqueness: true, presence: true
  validates :year_published, presence: true,
    numericality: {
    greater_than_or_equal_to: 1900,
    less_than_or_equal_to: Time.now.year }
end
