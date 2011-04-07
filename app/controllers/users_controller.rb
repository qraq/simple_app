class UsersController < ApplicationController
  
  
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  def destroy 
    User.find(params[:id]).destroy
    flash[:success] = "user nuked!"
    redirect_to users_path
    
  end
  
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])

  end
  
  def new
   @user = User.new
   @title = "Sign up"
  end


  def show
    @user = User.find(params[:id])
  end


  def create
  @user = User.new(params[:user])
  if @user.save
    sign_in @user
    flash[:success] = "Welcome to the Sample App!"
    redirect_to @user
  else
    @title = "Sign up"
    @user.password =""
  
      render 'new'
    
  end
  end
  
  def edit
  
    @title = "edit user"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
    @title = "Edit user"
    render 'edit'
    end
       
end

private
  def authenticate
    deny_access unless signed_in?
  end
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirec_to(root_path) unless current_user.admin?
  end
end
