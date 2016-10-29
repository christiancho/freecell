require_relative 'board'

class Game

  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    until board.won? do
      @board.render
      @board.get_input
    end
    @board.set_message("YOU WON!")
    @board.render
  end

end
