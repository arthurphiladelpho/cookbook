require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    @csv = CSV.foreach(csv_file_path) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3])
    end
  end

  def all
    @recipes
  end

  def clear
    @recipes = []
    CSV.open(@csv_file_path, "w") do |csv|
      ""
    end
  end

  def add_recipe(recipe)
    @recipes << recipe
    CSV.open(@csv_file_path, "ab") do |csv|
      csv << [recipe.name, recipe.description, recipe.prep_time, recipe.done]
    end
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    CSV.open(@csv_file_path, "w") do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.done]
      end
    end
  end
end
