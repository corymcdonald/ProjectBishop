class UsersController < ApplicationController

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
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Project Bishop!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:firstName, :email, :password,
                                   :password_confirmation)
    end
end