class MajorsController < ApplicationController
  
  def index
    @major = Major.select('DISTINCT major')
  end
  
  def new
  end
  
  def show
    @courses = []
    @major = Major.where('major like ?', params[:id])
    @major.each do |major|
      begin
        @courses.push(Course.where('name = ?', major.course).take!)
      rescue
      end
    end
  end
  
  def create
    @major = Major.new(new_params)
    @major.save
    redirect_to majors_path
  end
  
  private
  def new_params
    params.require(:major).permit(:major, :course)
  end
end
