require 'nokogiri'
require 'open-uri'
require_relative "view"
require_relative "recipe"

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    @view.print_list(@cookbook.all)
  end

  def create
    name = @view.ask_question("What's your recipe name?")
    description = @view.ask_question("What's your description?")
    prep_time = @view.ask_question("What's your prep_time")
    difficulty = @view.ask_question("What's the difficulty?")
    @cookbook.add_recipe(Recipe.new(name, description, prep_time, difficulty))
  end

  def destroy
    list
    index = @view.select_new_recipe
    @cookbook.remove_recipe(index)
  end

  def destroy_all
    @cookbook.clear
  end

  def search
    keyword = @view.ask_question("What would you like to search, young grasshopper?")
    url = open("https://www.marmiton.org/recettes/recherche.aspx?aqt=#{keyword}").read
    recipes = Nokogiri::HTML(url).search('h4.recipe-card__title').to_a
    top_5 = recipes.map do |recipe|
      recipe.text
    end.slice(0, 5)
    @view.print_search_results(top_5)
    selected_index = @view.select_new_recipe
    recipe_name = top_5[selected_index]
    description = find_description(url)[selected_index]
    prep_time = find_prep_time(url)[selected_index]
    @cookbook.add_recipe(Recipe.new(recipe_name, description, prep_time))
    list
  end

  def find_description(url)
    descriptions = Nokogiri::HTML(url).search('.recipe-card__description')
    descriptions.map do |recipe|
      recipe.text.split(".")[1]+"."
    end.slice(0, 5)
  end

  def find_prep_time(url)
    prep_time = Nokogiri::HTML(url).search('.recipe-card__duration__value')
    prep_time.map do |recipe|
      recipe.text
    end.slice(0, 5)
  end

  def mark_as_done!
    selected_index = @view.select_new_recipe
    recipe = @cookbook.all[selected_index]
    selected_recipe = @view.ask_question("Mark #{recipe.name} as done?")
    recipe.done = "true"
    @cookbook.remove_recipe(selected_index)
    @cookbook.add_recipe(recipe)
  end

end
