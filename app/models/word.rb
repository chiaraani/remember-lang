class Word < ApplicationRecord
  validates :spelling, presence: true, uniqueness: true

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

  def higher_hierarchy?(word, inspected = [])
    return true if defined.include? word
    inspected << self
    to_inspect = defined - inspected
    to_inspect.any? { |w| w.higher_hierarchy?(word, inspected)  }
  end

  attr_reader :new_definer
  def add_definer(word_spelling)
    errors.clear
    definer_validation(word_spelling)
    definers << @new_definer if errors.none?
    errors.none?
  end

  has_many :reviews, dependent: :destroy

  def create_next_review
    review = reviews.build
    if last_performed_review&.passed
      review.scheduled_for = (last_performed_review.waiting_time * Remember::INCREASE).round.days.from_now
    else
      review.scheduled_for = Date.tomorrow
    end
    review.save
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

  private
    def definer_validation(value)
      if value.blank?
        errors.add :new_definer, :blank 
        return
      end

      if @new_definer = Word.find_by_spelling(value)
        errors.add :base, :invalid, message: 'can NOT define itself' if self == @new_definer
        errors.add :base, :invalid, message: 'can NOT define the same word twice' if definers.include? @new_definer
        errors.add :base, :invalid, message: 'can NOT define and be defined by the same word' if higher_hierarchy?(@new_definer)
      else
        errors.add :new_definer, :invalid, message: 'is not recorded as a word'
      end
    end
end
