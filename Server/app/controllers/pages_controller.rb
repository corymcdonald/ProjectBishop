class PagesController < ApplicationController
  

  # GET /homes
  def index
  end
  
  def settings
  end
  
  def dashboard
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
  end
  
  def register
  end
  
  def searchresults
  end
  
  def profile
  end
  
end
