class GeneraleducationrequirementsController < ApplicationController
  def index
    @GeneralEducationRequirement = GeneralEducationRequirement.all
    
  end
  
  def new
    @GeneralEducationRequirement = GeneralEducationRequirement.new
  end
  
  def create
    @GeneralEducationRequirement = GeneralEducationRequirement.new(my_params)
   
    @GeneralEducationRequirement.save
    redirect_to generaleducationrequirements_path
  end
  
  def update
    @GeneralEducationRequirement = GeneralEducationRequirement.find(params[:id])
    if @GeneralEducationRequirement.update(my_params)
      redirect_to generaleducationrequirements_path
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
 
    redirect_to generaleducationrequirements_path
  end

    
  private
    def my_params
      # In the future don't freaking name models with camel case just one big headache
      if(params[:GeneralEducationRequirement])
        params.require(:GeneralEducationRequirement).permit(:course, :requirement)
      else
        params.require(:general_education_requirement).permit(:course, :requirement)
      end
    end
  
end
