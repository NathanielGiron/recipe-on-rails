class RecipesController < ApplicationController
  
  def index
    @recipes = Recipe.all
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = Chef.find(2)
    
    if @recipe.save
      flash[:success] = "Your recipe was posted!"
      redirect_to recipes_path
    else
      render :new
    end
  end
  
  def show
    @recipe = Recipe.find(params[:id])
  end
  
  private
    def recipe_params
      params.require(:recipe).permit(:name, :summary, :description)
    end
end