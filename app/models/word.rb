class Word < ApplicationRecord
  has_and_belongs_to_many :defined, 
    class_name: 'Word', 
    join_table: 'defined_definers', 
    association_foreign_key: 'defined_id', 
    foreign_key: 'definer_id'
  has_and_belongs_to_many :definers, 
    class_name: 'Word', 
    join_table: 'defined_definers', 
    association_foreign_key: 'definer_id', 
    foreign_key: 'defined_id'

  validates :spelling, presence: true, uniqueness: true
  has_many :reviews, dependent: :delete_all

  def create_next_review
    review = reviews.build
    if last_performed_review and last_performed_review.passed
      review.arrange((last_performed_review.waiting_time * Remember::INCREASE).round.days.from_now)
    else
      review.arrange(Date.tomorrow)
    end
  end

  def last_performed_review
     reviews.order(:performed_at).last
  end
end
