class RecipesController < ApplicationController
	before_action :find_recipe, only: [:show, :edit, :update, :destroy]
	before_action :require_user, except: [:index, :show]
	before_action :authenticate, only: [:edit]

	def index
		if params[:search]
			@search = Recipe.search do
				fulltext params[:search]
			end
			@recipes = @search.results
			redirect_to root_path, notice: "Nothing matched your search. Please try again" if @recipes.blank?
		else 
			@recipes = Recipe.order("created_at DESC")
		end
			# NOTE: This is used in prod since I'm not using Solr in prod
	    # if params[:search]
	    #   @recipe = Recipe.search(params[:search])
	    # else
	    #   @recipe = Recipe.order("created_at DESC")
	    # end
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

	def view #profile page with eager loading
		@recipe = Recipe.includes(:ingrediants, :directions).select{|recipe| recipe.user_email == current_user.email}
	end

	private

	def find_recipe
		@recipe = Recipe.friendly.find(params[:id])
	end

	def recipe_params
		params.require(:recipe).permit(:title, :description, :image, :slug, ingrediants_attributes: [:id, :name, :_destroy], directions_attributes: [:id, :order, :_destroy])
	end

end
