class Review < ApplicationRecord
  validates :scheduled_for, presence: true
  belongs_to :word
  scope :pending, -> { where("scheduled_for <= ?", Date.today).notdone }
  scope :notdone, -> { where(made_at: nil) }

  def meantime
    (scheduled_for - created_at.to_date).to_i
  end
end
