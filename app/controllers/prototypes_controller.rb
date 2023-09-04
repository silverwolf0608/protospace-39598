class PrototypesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show] 
  before_action :move_to_index, only: [:edit, :destroy] 
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end
  

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
  end

  def update
    @prototype.update(prototype_params)
    if @prototype.save
      redirect_to prototype_path(@prototype)
    else
      render :edit,status: :unprocessable_entity
    end
  end

  def destroy
    @prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    access_prototype = Prototype.find(params[:id])
    unless user_signed_in? && access_prototype.user == current_user
      redirect_to action: :index
    end
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
end