Project Bishop
=============
For this project we are creating a schedule assistant that helps students select classes based on what courses they still need to take and which classes are better suited for their degree program. 

Project Overview
=============
#### Pages
* Index
* User profiles
* Dashboard
* User Settings
* Registration

#### Project Languages
* CSS
* Ruby
* Javascript
* SQL
* Git
* HTML

Project reponsibilities
=============
#### Lucas Dorrough
* Style sheet design
* Static page design
* Responsive design implementation
* Grapic weekly schedule view

#### Will Turner
* User database entries
* registration
* User Settings
* Login
* Password encryption
* Server set up

#### Matt Luther
* Schedule generation algorithms
* Major flowchart generation algorithms
* Schedule database entries
* Create new schedule
* Remove schedule


#### Cory McDonald
* Scraping of Courses
* Scraping of Sections
* Major database entries
* Section Databse entries
* Course Database entries
* Creating Major

Database Migrations
=============

#### Courses
```ruby
 create_table "courses", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "coreqDesc"
    t.text     "coreqData"
    t.text     "prereqDesc"
    t.text     "prereqData"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "coreRequirement"
    t.string   "name"
  end
```
#### Sections
```ruby
create_table "sections", force: true do |t|
    t.string  "status"
    t.string  "courseID"
    t.string  "title"
    t.string  "component"
    t.string  "session"
    t.string  "hour"
    t.integer "classNumber"
    t.time    "startDate"
    t.time    "endDate"
    t.string  "classTime"
    t.string  "location"
    t.string  "instructor"
    t.string  "enrolled"
    t.string  "size"
    t.string  "career"
    t.string  "school"
    t.string  "department"
    t.string  "campus"
    t.string  "name"
    t.string  "section"
    t.string   "name"
  end
```

#### Users
```ruby
  create_table :users do |t|
     t.string :firstName
     t.string :lastName
     t.string :email
     t.string :salt
     t.string :password
     t.string :major
     t.timestamps
   end
```

#### Majors
```ruby
create_table "majors", force: true do |t|
    t.string   "major"
    t.string   "course"
    t.string   "year"
    t.string   "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
```


