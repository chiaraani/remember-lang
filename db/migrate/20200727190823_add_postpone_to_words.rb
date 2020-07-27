class AddPostponeToWords < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :postpone, :boolean, default: false
  end
end
