class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.date :scheduled_for, null: false
      t.boolean :passed
      t.belongs_to :word, foreign_key: true, null: false
      t.datetime :made_at

      t.datetime :created_at, null: false
    end
  end
end
