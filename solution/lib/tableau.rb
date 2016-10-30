require_relative 'card'

class Tableau

  def initialize(cards = [])
    @cards = cards
    @cards_taken = []
  end

  def add_cards(cards)
    unless empty? || cards.first.stackable?(last) || @cards_taken == cards
      raise UserError.new("card(s) cannot be stacked on this tableau")
    else
      until cards.empty? do
        @cards << cards.shift
      end
      @cards_taken = []
    end
  end

  def empty?
    @cards.empty?
  end

  def last
    @cards.last
  end

  def [](index)
    @cards[index]
  end

  def grabbable?(index)
    while index < count - 1 do
      return false unless self[index + 1].stackable?(self[index])
      index += 1
    end
    true
  end

  def grab(index)
    raise UserError.new("cannot grab that card") unless grabbable?(index)
    @cards_taken = @cards.slice!(index .. -1)
    @cards_taken
  end

  def count
    @cards.length
  end

end
