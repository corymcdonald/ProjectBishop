class ChangeLogins < ActiveRecord::Migration
  def change
    change_table :logins do |t|
      t.remove :title, :notes
      t.string :user_name
      t.string :password
    end
  end
end
