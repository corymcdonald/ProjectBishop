class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :status
      t.string :courseID
      t.string :title
      t.string :component
      t.string :session
      t.string :hour
      t.integer :classNumber
      t.time :startDate
      t.time :endDate
      t.string :classDay
      t.string : classTime
      t.string :location
      t.string :instructor
      t.string :enrolled
      t.string :size
      t.string :career
      t.string :school
      t.string :department
      t.string :campus
    end
  end
end
