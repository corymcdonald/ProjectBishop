class PagesController < ApplicationController
  

  # GET /homes
  def index
  end
  
  def settings
  end
  
  def dashboard
  end
  
  def register
  end
  
  def searchresults
  end
  
  def profile
  end
  
  
  def flowchart
    require 'rasem'
    img = Rasem::SVGImage.new(100,100) do
      circle 20, 20, 5
      circle 50, 50, 5
      line 20, 20, 50, 50
      end
      
    @flowchart = img.output
    
    respond_to do |format|
      format.html { render :text => @flowchart}
    end
  end
  
end
