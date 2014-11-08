class CoursesController < ApplicationController
  def index
    @course = Course.all
  end
end
