class RecipesController < ApplicationController
	before_action :find_recipe, only: [:show, :edit, :update, :destroy]
	before_action :require_user, except: [:index, :show]

	def index
	    if params[:search]
	      @recipe = Recipe.search(params[:search]).order("created_at DESC")
	    else
	      @recipe = Recipe.order("created_at DESC")
	    end
	end

	def new
		@recipe = Recipe.new
	end

	def show
	end

	def create
		@recipe = Recipe.new(recipe_params)
		@recipe.user_email = current_user.email
		@recipe.user_name = "#{current_user.first_name} #{current_user.last_name}"
		if @recipe.save
			redirect_to @recipe, notice: "Recipe successfully created"
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @recipe.update(recipe_params)
			redirect_to @recipe, notice: "Recipe successfully updated"
		else
			render :edit
		end
	end

	def destroy
		@recipe.destroy
		redirect_to root_path, notice: "Recipe successfully deleted"
	end

	def view #profile page
		@recipe = Recipe.select{|recipe| recipe.user_email == current_user.email}
	end

	private

	def find_recipe
		@recipe = Recipe.friendly.find(params[:id])
	end

	def recipe_params
		params.require(:recipe).permit(:image, :title, :description, :slug, ingrediants_attributes: [:id, :name, :_destroy], directions_attributes: [:id, :order, :_destroy])
	end

end
