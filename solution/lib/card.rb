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
    cards = []
    Card.values.each do |value|
      Card.suits.each do |suit|
        cards << Card.new(value, suit)
      end
    end
    cards
  end

  attr_reader :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    if num.between?(2,10)
      num.to_s + SUIT_STRINGS[suit]
    else
      value.to_s[0].upcase + SUIT_STRINGS[suit]
    end
  end

  def num
    NUM_VALUES[value]
  end

  def stackable?(card)
    raise UserError.new("card is a king") if value == :king
    color == card.color || card.num != num + 1 ? false : true
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
