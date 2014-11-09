class MajorsController < ApplicationController
  
  def index
    @major = Major.select('DISTINCT major')
  end
  
  def new
  end
  
  def show
    @courses = []
    @major = params[:id]
    @majors = Major.where('major like ?', params[:id])
    @majors.each do |major|
      begin
        @courses.push(Course.where('name = ?', major.course).take!)
      rescue
      end
    end
  end
  
  def edit
    @major = Major.where('major = ?', params[:id])
    # render plain: @major.inspect
  end
  
  def update
    @major = Major.where('major = ?', params[:id]).where('course = ? ',params[:major]['course'])
    render plain: params.inspect
    # if @major.update(new_params)
    #   redirect_to @major
    # else
      # render 'edit'
    # end
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
