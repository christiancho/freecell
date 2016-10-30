require_relative 'card'

class Tableau

  def initialize(cards = [])
    @cards = nil
  end

  def add_cards(cards)

  end

  def empty?

  end

  def last

  end

  def [](index)

  end

  def grabbable?(index)

  end

  def grab(index)

  end

  def count

  end

  private

  def replaceable?(cards)
    @cards_taken == cards
  end

  attr_accessor :card_taken

end
