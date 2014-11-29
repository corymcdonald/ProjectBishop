class AdminController < ApplicationController
  def index
    @usercourse = Usercourse.all
    @major = Major.where('major like ?', 'computer science (bs)')
  end
end