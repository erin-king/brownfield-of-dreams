# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    render locals: {
      facade: GithubFacade.new(current_user),
      bookmarks: current_user.display_bookmarks
    }
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    @user.confirmation_token
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Logged in as #{@user.email}."
      ConfirmMailer.registration_confirmation(@user).deliver_now
      redirect_to dashboard_path
    else
      user_already_exists
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end

  def user_already_exists
    flash.now[:error] = 'Username already exists'
    render :new
  end
end
