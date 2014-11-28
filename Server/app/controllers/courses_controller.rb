class CoursesController < ApplicationController
  def index
    if params[:search]
      @course = Course.search(params[:search])
    else
      @course = Course.all
      
      @courses = {}
      @allcourses = []
      @temp = []
      
      for current in @course
        @temp.push(current.name[0,4])
        # @allcourses << [current.name[0,4], current]
      end
      @uniqcourses = @temp.uniq
    
      
      Rails.logger.info(DateTime.now)
      # @courses = @allcourses
      for current in @uniqcourses
        @courses[current] = @course.select{|x| x.name[0,4] == current }
      end
      Rails.logger.info(DateTime.now)
    end
  end
  
  def destroy
    @course = Course.find(params[:id])
    @course.destroy
 
  redirect_to courses_path
  end
  
  def new
    @course = Course.new
  end
  def create
    @course = Course.new(course_params)
   
    @course.save
    redirect_to @course
  end
  
  def show
    @course = Course.find(params[:id])
    @sections = Section.where('name = ?', @course.name.gsub(' ', ''))
  end
  
  def edit
    @course = Course.find(params[:id])
  end
  
  def update
     @course = Course.find(params[:id])
 
    if @course.update(course_params)
      redirect_to @course
    else
      render 'edit'
    end
  end
  
  private
    def course_params
      params.require(:course).permit(:title, :name, :description, :coreqDesc, :prereqDesc)
    end
  
end
