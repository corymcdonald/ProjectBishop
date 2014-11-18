class CoursesController < ApplicationController
  def index
    if params[:search]
      @course = Course.search(params[:search])
    else
      @course = Course.all

    end
  end
end
