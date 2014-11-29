class AdminController < ApplicationController
  def index
    @usercourse = Usercourse.all
  end
end