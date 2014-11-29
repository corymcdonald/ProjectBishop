class CreateGeneralEducationRequirements < ActiveRecord::Migration
  def change
    create_table :general_education_requirements do |t|
      t.string :requirement
      t.string :course

      t.timestamps
    end
  end
end
