class PrototypesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :new]
  before_action :move_to_index, except: [:index, :show]
  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    #プロトタイプオブジェクトを生成
    @prototype = Prototype.new
  end

  def create
    @prototype = current_user.prototypes.new(prototype_params)
    if @prototype.save
      redirect_to prototypes_path
    else
      render :new,status: :unprocessable_entity
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    @prototype.update(prototype_params)
    if @prototype.save
      redirect_to prototype_path(@prototype)
    else
      render :edit,status: :unprocessable_entity
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end
  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image)
  end

  def move_to_index
    access_prototype = Prototype.find(params[:id])
    unless user_signed_in? && access_prototype.user == current_user
      redirect_to action: :index
    end
  end
end