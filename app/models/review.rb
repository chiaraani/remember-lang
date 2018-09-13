class Review < ApplicationRecord
  validates :expires_at, presence: true
  belongs_to :word
  scope :pending, -> { where("expires_at <= ?", Date.today).notdone }
  scope :notdone, -> { where(done_at: nil) }
end
