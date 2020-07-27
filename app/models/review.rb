class Review < ApplicationRecord
  validates :scheduled_for, presence: true
  belongs_to :word
  scope :pending, -> { where("scheduled_for <= ?", Date.today).where(performed_at: nil, word: Word.where(postpone: false)) }
  scope :notperformed, -> { where(performed_at: nil) }
  scope :passed, -> { where(passed: true) }
  scope :performed_today, -> { where(performed_at: (Time.now.midnight)..Time.now) }
  scope :passed_today, -> { performed_today.passed }
  scope :arrange, -> { order(word_id: :desc).each { |review| review.arrange } }

  before_create do
    notperformed = word.reviews.where.not(created_at: nil).notperformed
    notperformed.last.perform(false) if notperformed.count > 0
  end

  def waiting_time
    ((performed_at or scheduled_for).to_date - created_at.to_date).to_i
  end

  def perform(pass)
    update!(performed_at: Time.now, passed: pass)
    self.reload
  end

  def arrange(date=scheduled_for)
    if performed_at == nil
      date = date.to_date
      loop do
        quantity = if date <= Date.today
                     Review.pending.count - 1
                   else
                     Review.where(scheduled_for: date).count
                   end
        break if quantity < Remember::MAX_PER_DAY
        date += 1
      end
      update!(scheduled_for: date) if scheduled_for != date
    end
  end
end
