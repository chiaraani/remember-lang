class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.date :expires_at, null: false
      t.boolean :passed
      t.belongs_to :word, foreign_key: true, null: false
      t.datetime :done_at

      t.datetime :created_at, null: false
    end
  end
end
