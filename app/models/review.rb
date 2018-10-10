class Review < ApplicationRecord
  validates :scheduled_for, presence: true
  belongs_to :word
  scope :pending, -> { where("scheduled_for <= ?", Date.today).notperformed }
  scope :notperformed, -> { where(performed_at: nil) }
  scope :passed, -> { where(passed: true) }
  scope :performed_today, -> { where(performed_at: (Time.now.midnight)..Time.now) }
  scope :passed_today, -> { performed_today.passed }

  before_create do
    notperformed = word.reviews.where.not(created_at: nil).notperformed
    notperformed.last.perform(false) if notperformed.count > 0
  end

  def meantime
    ((performed_at or scheduled_for).to_date - created_at.to_date).to_i
  end

  def previous
    if word.reviews.count > 1
      r = word.reviews.where('performed_at <= ?', created_at).last
      return r if r and r.passed
    end
    word.reviews.new(created_at: (created_at - (meantime / 2).round.days), performed_at: created_at, passed: true)
  end

  def perform(pass)
    update!(performed_at: Time.now, passed: pass)
    self.reload
  end
end
