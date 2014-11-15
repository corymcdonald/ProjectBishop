class CoursesController < ApplicationController
  def index
    if params[:search]
      @course = Course.search(params[:search])
      @format = true;
    else
      @course = Course.all
      @format = false;
    end
  end
end
