class DashboardController < ApplicationController
    require 'Schedule'
      
      
    def index
        @courses = Course.all
        @coursesList = []
        @courses.each do |p|
          @coursesList.push(p.name)
        end
        
        if(params.has_key?(:classes) )
            @classParams = params[:classes]
            
            sch = ::Schedule
         
            courses = Array.new
            
            for i in 0..@classParams.length
              # courses[i] = Course.find_by(name: @test[i])
                courses[i] = Course.where("lower(name) = ?",  @classParams[i]).first
                
            end
           @schArray = sch.genereateSchedules(courses).to_json
           respond_to do |format|
            format.json  { render :json => @schArray }
          end
       end
       
      if(params.has_key?(:classID) )
        @idParams = params[:classID]
        logger.info("TESSSSST")
        @sections = Section.where(name: @idParams.upcase ,component: 'Lecture') 
        respond_to do |format|
          format.json  { render :json => @sections }
        end
      end
       
        
    end
    
    def genSch
      
    end    

end
