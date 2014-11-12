class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.string :name
      t.string :coreRequirement
      t.text :description
      t.text :coreqDesc
      t.text :coreqData
      t.text :prereqDesc
      t.text :prereqData
      t.timestamps
    end
  end
end