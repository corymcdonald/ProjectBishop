class CreateClassesLists < ActiveRecord::Migration
  def change
    create_table :classes_lists do |t|
      t.string :user
      t.string :course
      t.string :grade

      t.timestamps
    end
  end
end
