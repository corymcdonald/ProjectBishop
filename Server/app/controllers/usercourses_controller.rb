class UsercoursesController < ApplicationController
  require 'Parsethis'
  before_action :logged_in_user
    
  def index
    @usercourses = Usercourse.where("user = ?", current_user.id)
    
    @Course = Course.all
    
    @ger = GeneralEducationRequirement.all
    @major = Major.where('major like ?', current_user.major)
    
    @results = [] #Classes that are acceptable for major
    @missing = []
    
    @major.each do |current|
      if current.course?
        logger.info('Currently on ' + current.course)
        current.course.strip
        @found = @usercourses.where(course: current.course.strip)
        
        if @found.empty?
          logger.info('Did NOT find ' + current.course)
          if current.course != 'FREE ELECTIVE' and current.course != 'ELECTIVE'
            @missing.push(current)
          end
          @ger.where(requirement: current.course.strip).each do |course|
            if @usercourses.where(course: course.course.strip).first
              if not @results.include?(course.course)
                logger.info("FOUND A CLASS THAT CAN BE SUBTITUTED")
                @usercourses.where(course: course.course).first.course
                @missing.delete(current)
                @results.push(course)
                break
              end
            end
          end
        else
          logger.info('FOUND ' + current.course)
          @results.push(@found)
        end
      
      end
    end
    
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
