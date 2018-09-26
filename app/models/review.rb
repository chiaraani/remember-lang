class Review < ApplicationRecord
  validates :scheduled_for, presence: true
  belongs_to :word
  scope :pending, -> { where("scheduled_for <= ?", Date.today).notperformed }
  scope :notperformed, -> { where(performed_at: nil) }

  def meantime
    ((performed_at or scheduled_for).to_date - created_at.to_date).to_i
  end

  def previous
    if word.reviews.count > 1
      word.reviews.where('performed_at <= ?', created_at).last
    else
      word.reviews.new(created_at: (created_at - (meantime / 2).round.days), performed_at: created_at, passed: true)
    end
  end
end
