class MajorsController < ApplicationController
  
  def index
    @major = Major.select('DISTINCT major')
  end
  
  def new
  end
  
  def show
    @courses = []
    @major = params[:id]
    @majors = Major.where('major like ?', params[:id])
    @majors.each do |major|
      begin
        @courses.push(Course.where('name = ?', major.course).take!)
        # render plain: @courses.inspect
      rescue
        @tempCourse = Course.new(title: major.course)
        @courses.push(@tempCourse)
      end
    end
    
    # render plain: @courses.inspect
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
      redirect_to majors_url + '/' + params[:id]
    else
      render 'edit'
    end
  end
  
  def create
    @major = Major.new(new_params)
    
    @major.save
    redirect_to majors_path
  end
  
  private
    def new_params
      params.require(:major).permit(:major, :course)
    end
end
