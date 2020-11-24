class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(new create)

  def new
    @user = User.new
  end

  def show
    return if @user

    flash[:warning] = t "show.warning"
    redirect_to login_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "create.success"
      redirect_to root_path
    else
      flash[:warning] = t "create.warning"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "update.success"
      redirect_to @user
    else
      flash[:warning] = t "update.unsuccess"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation,
                  :phone, :image)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "load_user.warning"
    redirect_to signup_path
  end
end
