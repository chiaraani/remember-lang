class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :spelling, null: false

      t.timestamps
    end
    add_index :words, :spelling, unique: true
  end
end
