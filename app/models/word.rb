class Word < ApplicationRecord
  has_and_belongs_to_many(:defined, 
    class_name: 'Word', 
    join_table: 'defined_definers', 
    association_foreign_key: 'defined_id', 
    foreign_key: 'definer_id')
  has_and_belongs_to_many(:definers, 
    class_name: 'Word', 
    join_table: 'defined_definers', 
    association_foreign_key: 'definer_id', 
    foreign_key: 'defined_id')
  attr_accessor :new_definer
  validates_each :new_definer, allow_nil: true, allow_blank: false do |record, attr, value|
    errors = []
    if record.new_definer = Word.find_by_spelling(value)
      errors << 'can NOT define and be defined by the same word' if record.defined.include? record.new_definer
    else
      errors << 'is not recorded as a word'
    end
    errors.each { |e| record.errors.add(attr, e) }
  end


  def add_definer(definer)
    @new_definer = definer
    if saved = valid?
      definers << new_definer
    end
    saved
  end

  validates :spelling, presence: true, uniqueness: true
  has_many :reviews, dependent: :destroy

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

  def learned
    last_performed_review&.passed and last_performed_review.waiting_time >= Remember::LEARNED_TIME
  end

  def should_postpone
    update!(postpone: not(definers.all?(&:learned)))
    defined.each { |w| w.update!(postpone: true) } if postpone
    defined.each { |w| w.should_postpone } if learned
  end
end
