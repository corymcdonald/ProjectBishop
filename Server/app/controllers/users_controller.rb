class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  
  def show
    if(params.has_key?(:id) )
      @user = User.find(params[:id])
      @loggedin = true
    else
      @user = User.all
      @loggedin = false
    end
  end

  def new
    @majors = Major.select('DISTINCT major').order('major')
    @major = []
    for current in @majors
      @major.push(current.major.titleize)
    end
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      remember @user
      flash[:success] = "Welcome to Project Bishop!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def destroy
  end
  
  def update
    @user = User.find(params[:id])
    if params[:old_password] != "" && (@user.authenticate(params[:old_password][0])) && @user.update_attributes(user_params) 
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @majors = Major.select('DISTINCT major').order('major')
      @major = []
      for current in @majors
        @major.push(current.major.titleize)
      end
      render 'edit'
    end
  end
  
  def edit
    @majors = Major.select('DISTINCT major').order('major')
    @major = []
    for current in @majors
      @major.push(current.major.titleize)
    end
    @user = User.find(params[:id])
  end
  
  private

    def user_params
      params.require(:user).permit(:firstName, :lastName, :major, :email, :password,
                                   :password_confirmation, :remember_digest)
    end
    
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end