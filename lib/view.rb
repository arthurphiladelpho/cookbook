require_relative "controller"

class View
  def print_list(recipes)
    puts "You got no recipes yet..." if recipes.length.zero?
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}. [#{recipe.done == "true" ? "X" : " "}] #{recipe.name.capitalize} - #{recipe.description} (#{recipe.prep_time})."
    end
  end

  def ask_question(question)
    puts question
    print "--> "
    gets.chomp
  end

  def select_new_recipe
    puts "Pick a recipe ..."
    print "--> "
    gets.chomp.to_i - 1
  end

  def print_search_results(recipes_array)
    puts "Here are some delicious dishes:"
    recipes_array.each_with_index do |recipe, index|
      puts "#{index + 1}. #{recipe}"
    end
  end
end
