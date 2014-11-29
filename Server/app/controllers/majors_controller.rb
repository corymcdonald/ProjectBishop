class MajorsController < ApplicationController
  
  
  def index
    @major = Major.select('DISTINCT major').order('major')
    
    # @major = Major.where('major like ?', '%Chemical%')
    
    @major.each do |major|
      # major.major = 'chemical engineering'
      # major.save
    end
    # render plain: @major.count
  end
  
  
  def new
    @major = Major.new
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
    @major = Major.find(params[:major_id])
    
    if @major.update(new_params)
      redirect_to majors_url
    else
      render 'edit'
    end
  end
  
  def create
    @major = Major.new(new_params)
    @major.save
    if(params[:async])
      redirect_to majors_path + '/' + @major.major.gsub(' ', '%20') +  '/edit'
    else
      redirect_to majors_path
    end
    
  end
  
  def destroy
    @major = Major.find(params[:id])
    @major.destroy
    
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
