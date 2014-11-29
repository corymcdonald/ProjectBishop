class UsercoursesController < ApplicationController
  require 'Parsethis'
  before_action :logged_in_user
    
  def index
    @usercourses = Usercourse.all
    
  end
  
  def new
    @courses = Course.all
    @coursesList = []
    @courses.each do |p|
      @coursesList.push(p.name)
    end
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
    
    @courses = Course.all
    @coursesList = []
    @courses.each do |p|
      @coursesList.push(p.name)
    end
  end
  
  def create
    if new_params
      @usercourse = Usercourse.new(new_params)
      @usercourse.save
      redirect_to usercourses_path

    else
      transcript = ::Parsethis
      transcript.parseIt(params[:transcript], current_user)
      redirect_to usercourses_path
    end
    
  end

  private
    def new_params
      if(params[:usercourse])
        params.require(:usercourse).permit(:user, :course, :grade)
      end
    end
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
