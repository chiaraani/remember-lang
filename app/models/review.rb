class Review < ApplicationRecord
  validates :scheduled_for, presence: true
  belongs_to :word
  scope :pending, -> { where("scheduled_for <= ?", Date.today).notdone }
  scope :notdone, -> { where(done_at: nil) }

  def meantime
    ((done_at or scheduled_for).to_date - created_at.to_date).to_i
  end

  def previous
    if word.reviews.count > 1
      word.reviews.where('done_at <= ?', created_at).last
    else
      word.reviews.new(created_at: (created_at - (meantime / 2).round.days), done_at: created_at, passed: true)
    end
  end
end
