class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.datetime :expires_at
      t.boolean :passed
      t.belongs_to :word, foreign_key: true

      t.timestamps
    end
  end
end
