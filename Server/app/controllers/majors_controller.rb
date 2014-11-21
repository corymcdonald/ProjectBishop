class MajorsController < ApplicationController
  
  
  def index
    @major = Major.select('DISTINCT major')
  end
  
  
  def new
  end
  
  def show
    @courses = []
    
    @major = params[:id].downcase
    @coursesInMajors = Major.where('major like ?', params[:id])
    
    @coursesInMajors.each do |major|
      begin
          @courses.push(major: major ,course: Course.where('name = ?', major.course).take!)
      rescue
        @tempCourse = Course.new(title: major.course,name: major.course)
        @courses.push(major: major, course: @tempCourse)
      end
    end
    
    # render plain: @courses[0].inspect
  end
  
  def edit
    @majors = Major.where('major = ?', params[:id])
    @major = Major.new()
    @major.major = params[:id]
    @courses = Course.all
    @coursesList = []
    @courses.each do |p|
      @coursesList.push(p.name)
    end
    
  end
  
  def update
    majorSeedPath = "db/majorSeed.rb"
    File.open(majorSeedPath, "a") do |f|
      f.write('Major.find(' + params[:major_id] +').update(' + new_params.to_s + ')')
      f.puts @string
    end
    
    @major = Major.find(params[:major_id])
    if @major.update(new_params)
      redirect_to majors_url + '/' + params[:id]
    else
      render 'edit'
    end
  end
  
  def create
    majorSeedPath = "db/majorSeed.rb"
    File.open(majorSeedPath, "a") do |f|
      f.write('Major.new(' + new_params.to_s + ')')
      f.puts @string
    end
    
    @major = Major.new(new_params)
    @major.save
    if(params[:async])
      redirect_to majors_path + '/' + @major.major +  '/edit'
    else
      redirect_to majors_path
    end
    
  end
  
  def destroy
    @major = Major.find(params[:id])
    @major.destroy
    
    majorSeedPath = "db/majorSeed.rb"
    File.open(majorSeedPath, "a") do |f|
      f.write('Major.destroy(' + new_params.to_s + ')')
      f.puts @string
    end
    
    # redirect_to majors_path + '/' + @major.major +  '/edit'
  end
  
  private
    def new_params
      if params[:major]["course"]
        params[:major]["course"] = params[:major]["course"].upcase
      end
      if params[:major]["major"]
        params[:major]["major"] = params[:major]["major"].downcase
      end
      params.require(:major).permit(:major, :course, :year, :semester)
    end
end
