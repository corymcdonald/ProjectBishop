class GeneraleducationrequirementsController < ApplicationController
  def index
    @GeneralEducationRequirement = GeneralEducationRequirement.all
  end
  
  def new
    @GeneralEducationRequirement = GeneralEducationRequirement.new
  end
  
  def create
    @GeneralEducationRequirement = GeneralEducationRequirement.new(GeneralEducationRequirement_params)
   
    @GeneralEducationRequirement.save
    redirect_to @GeneralEducationRequirement
  end
  
  def show
    @GeneralEducationRequirement = GeneralEducationRequirement.find(params[:id])
  end
  
  def update
    @GeneralEducationRequirement = GeneralEducationRequirement.find(params[:id])
 
    if @GeneralEducationRequirement.update(GeneralEducationRequirement_params)
      redirect_to @GeneralEducationRequirement
    else
      render 'edit'
    end
  end
  
  def edit
    @GeneralEducationRequirement = GeneralEducationRequirement.find(params[:id])
  end
  
  def destroy
    @GeneralEducationRequirement = GeneralEducationRequirement.find(params[:id])
    @GeneralEducationRequirement.destroy
 
    redirect_to GeneralEducationRequirements_path
  end

    
  private
    def GeneralEducationRequirement_params
      params.require(:GeneralEducationRequirement).permit(:course, :requirement)
    end
  
end
