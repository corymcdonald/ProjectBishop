class SectionsController < ApplicationController
  def index
    @section = Section.search(params[:search])
  end
  
  def new
    @section = Section.new
  end
  def create
    @section = Section.new(section_params)
   
    @section.save
    redirect_to @section
  end
  
  def show
    @section = Section.find(params[:id])
  end
  
  def edit
    @section = Section.find(params[:id])
    session[:return_to] ||= request.referer
  end
  
  def update
    @section = Section.find(params[:id])
    
    if @section.update(section_params)
      redirect_to session.delete(:return_to)
    else
      render 'edit'
    end
  end
  
  def destroy
    @section = Section.find(params[:id])
    @section.destroy
    
    redirect_to sections_path
  end
  
  private
    def section_params
      params.require(:section).permit(:title, :name, :section, :courseID, :status, :component, :session, :hour, :classNumber, :startDate, :endDate, :classTime, :location, :instructor, :enrolled, :size, :career, :school, :department, :campus)
      
    end
  
  
end
