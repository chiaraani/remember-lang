class Word < ApplicationRecord
  validates :spelling, presence: true
  has_many :reviews
end
