class UsercoursesController < ApplicationController
  def index
    @usercourse = Usercourse.all
  end
  
  def new
    @courses = Course.all
    @coursesList = []
    @courses.each do |p|
      @coursesList.push(p.name)
    end
    @coursesList.push('p.name')
  end
  
  
  def destroy
    @usercourse = Usercourse.find(params[:id])
    @usercourse.destroy
   
    redirect_to usercourses_path
  end
  
  def update
    @usercourse = Usercourse.find(params[:id])
    
    if @usercourse.update(new_params)
      redirect_to usercourses_path
    else
      render 'edit'
    end
  end
  
  
  def edit
    @usercourse = Usercourse.find(params[:id])
  end
  
  def create
    @usercourse = Usercourse.new(new_params)
    @usercourse.save
    redirect_to usercourses_path
    
  end

  private
    def new_params
      
      params.require(:usercourse).permit(:user, :course, :grade)
    end
end
