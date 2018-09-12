class Review < ApplicationRecord
  validates :expires_at, presence: true
  belongs_to :word
end
