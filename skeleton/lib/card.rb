require 'colorize'
require_relative 'errors'

class Card

  def self.suits
    [:spade, :diamond, :club, :heart]
  end

  def self.values
    [
      :ace,
      :two,
      :three,
      :four,
      :five,
      :six,
      :seven,
      :eight,
      :nine,
      :ten,
      :jack,
      :queen,
      :king
    ]
  end

  def self.all_cards

  end

  attr_reader :value, :suit

  def initialize(value, suit)

  end

  def to_s

  end

  def num

  end

  def stackable?(card)
    # use the Card::color method down below!
  end

  def display(bg_color = :white)
    to_s.rjust(3).colorize(:background => bg_color, :color => color)
  end

  protected

  def color
    case suit
    when :spade, :club
      :black
    when :heart, :diamond
      :red
    end
  end

  NUM_VALUES = {
    :ace => 1,
    :two => 2,
    :three => 3,
    :four => 4,
    :five => 5,
    :six => 6,
    :seven => 7,
    :eight => 8,
    :nine => 9,
    :ten => 10,
    :jack => 11,
    :queen => 12,
    :king => 13
  }

  SUIT_STRINGS = {
    :spade => "♠",
    :heart => "♥",
    :club => "♣",
    :diamond => "♦"
  }

end
