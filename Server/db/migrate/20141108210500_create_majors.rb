class CreateMajors < ActiveRecord::Migration
  def change
    create_table :majors do |t|
      t.string :major
      t.string :course

      t.timestamps
    end
  end
end
