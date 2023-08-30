class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :new]
  def show
    @user = User.find(params[:id])
    @name = @user.name
    @profile = @user.profile
    @occupation = @user.occupation
    @position = @user.position
  end
end