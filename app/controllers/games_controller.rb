require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @output = params
    @result = run_game(params[:word_input], params[:letters_arr].split)
  end
end

# logic for game
# case 0 = Not an english word
# case 1 = Not in the grid
# case 2 = Success

def generate_grid(grid_size)
  sample = []
  grid_size.times { sample << ('A'..'Z').to_a.sample }
  sample
end

def chars_in_grid?(attempt_arr, grid)
  attempt_arr.all? do |char|
    grid.include?(char)
  end
end

def json_parser(attempt)
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  JSON.parse(open(url).read)
end

def game_logic_inside(attempt_arr, grid)
  attempt_arr.each do |char|
    return [1, 0] unless grid.find_index(char)

    temp = grid.find_index(char)
    grid.delete_at(temp)
  end
  []
end

def game_logic(attempt_arr, grid)
  answer_arr = []
  answer_arr += if chars_in_grid?(attempt_arr, grid)
                  game_logic_inside(attempt_arr, grid)
                else
                  [1, 0]
                end
  answer_arr
end

def run_game(attempt, grid)
  # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
  score = 5 + attempt.length
  answer_arr = [3, score]
  x = game_logic(attempt.upcase.chars, grid)
  if x != []
    answer_arr[0] = x[0]
    answer_arr[1] = x[1]
  end
  answer_arr = [0, 0] unless json_parser(attempt)['found']
  { game_state: answer_arr[0], score: answer_arr[1] }
end
