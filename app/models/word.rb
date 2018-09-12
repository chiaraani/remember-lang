class Word < ApplicationRecord
  validates :spelling, presence: true, uniqueness: true
  has_many :reviews, dependent: :delete_all
end
