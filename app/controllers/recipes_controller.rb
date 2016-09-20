class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :show, :destroy, :like]
  before_action :require_user, except: [:show, :index]
  before_action :require_same_user, only: [:edit, :update]
  
  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 3).order(created_at: :desc)
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = current_user
    
    if @recipe.save
      flash[:success] = "Your recipe was posted!"
      redirect_to recipes_path
    else
      render :new
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Your recipe was updated!"
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end
  
  def destroy
    @recipe.destroy
      flash[:error] = "Recipe was successfully deleted!"
      redirect_to recipes_path
  end
  
  def like
    Like.create(like: params[:like], chef: current_user, recipe: @recipe)
    if params[:like] == "true"
      flash[:success] = "You liked this recipe."
    else
      flash[:warning] = "You disliked this recipe."
    end
    redirect_to :back
  end
  
  private
    def recipe_params
      params.require(:recipe).permit(:name, :summary, :description)
    end
    
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
    
    def require_same_user
      if current_user != @recipe.chef
        flash[:error] = "You can only edit your own recipes"
        redirect_to recipes_path
      end
    end
end