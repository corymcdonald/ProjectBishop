class CoursesController < ApplicationController
  def index
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
  
  def show
    @course = Course.find(params[:id])
    @sections = Section.where('name = ?', @course.name.gsub(' ', ''))
    @numOfPreReqs =JSON.parse(@course.prereqData).count
    
  end
end
