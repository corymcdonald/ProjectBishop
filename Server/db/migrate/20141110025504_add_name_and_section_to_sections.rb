class AddNameAndSectionToSections < ActiveRecord::Migration
  def change
    add_column :sections, :name, :string
    add_column :sections, :section, :string
  end
end
