class Word < ApplicationRecord
  validates :spelling, presence: true
end
