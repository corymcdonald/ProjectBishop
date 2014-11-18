class SectionsController < ApplicationController
  def index
    @section = Section.all
  end
end
