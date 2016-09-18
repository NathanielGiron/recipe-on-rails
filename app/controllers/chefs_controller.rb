class ChefsController < ApplicationController
  before_action :set_chef, only: [:show, :edit, :update]
  before_action :require_user, only: [:show, :index]
  before_action :require_same_user, only: [:edit, :update]
  
  def index
    @chefs = Chef.paginate(page: params[:page], per_page: 3).order(created_at: :desc)
  end
  
  def new
    @chef = Chef.new
  end
  
  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      flash[:success] = "Your account has been created!"
      redirect_to recipes_path
    else
      render 'new'
    end
  end
  
  def show
    @recipes = @chef.recipes.paginate(page: params[:page], per_page: 3).order(created_at: :desc)
  end
  
  def edit
  end
  
  def update
    if @chef.update(chef_params)
      flash[:success] = "Your profile has been updated!"
      redirect_to chef_path(@chef)
    else
      render 'edit'
    end
  end
  
  private
    def chef_params
      params.require(:chef).permit(:chefname, :email, :password)
    end
    
    def set_chef
      @chef = Chef.find(params[:id])
    end
    
    def require_same_user
      if current_user != @chef
        flash[:error] = "You can only edit your own profile"
        redirect_to root_path
      end
    end
end