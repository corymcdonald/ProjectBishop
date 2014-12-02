class DashboardController < ApplicationController
    require 'Schedule'
      
      
    def index
        require 'rasem'
        img = Rasem::SVGImage.new(1000,700) do
          with_style :fill=>"#6fcde3", :stroke=>"black" do
            line 100, 100, 250, 250
            line 400, 100, 550, 400
            line 100, 100, 100, 250
            line 400, 250, 550, 550
            line 400, 400, 400, 250
            circle 100, 100, 50
            circle 250, 250, 50
            circle 400, 100, 50
            circle 550, 400, 50
            circle 100, 250, 50
            circle 250, 400, 50
            circle 400, 250, 50
            circle 100, 400, 50
            circle 250, 550, 50
            circle 400, 400, 50
            circle 550, 550, 50
          end
        end
        @flowchart = img.output
        
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
       end
       
       respond_to do |format|
        format.html 
        format.json  { render :json => @schArray }
      end
        
    end
    
    def genSch
      
    end    

end
