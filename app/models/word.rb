class Word < ApplicationRecord
  has_and_belongs_to_many(:defined, 
    class_name: 'Word', 
    join_table: 'defined_definers', 
    association_foreign_key: 'defined_id', 
    foreign_key: 'definer_id') do
      def <<(define_another)
        if proxy_association.owner.definers.include? define_another
          DefinedDefinersValidator.errors_for(proxy_association.owner)
          self
        else
          super
        end
      end
    end
  has_and_belongs_to_many(:definers, 
    class_name: 'Word', 
    join_table: 'defined_definers', 
    association_foreign_key: 'definer_id', 
    foreign_key: 'defined_id') do
      def <<(new_definer)
        if proxy_association.owner.defined.include? new_definer
          DefinedDefinersValidator.errors_for(proxy_association.owner)
          self
        else
          super
        end
      end
    end

  class DefinedDefinersValidator < ActiveModel::Validator
    def validate(record)
      unless (record.definer_ids - record.defined_ids) == record.definer_ids
        DefinedDefinersValidator.errors_for(record)
      end
    end

    def self.errors_for(record)
      message = 'A word can NOT define and be defined by the same word.'
      [:definers, :defined].each { |field| record.errors[field] << message }
    end
  end

  include ActiveModel::Validations
  validates_with DefinedDefinersValidator

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
