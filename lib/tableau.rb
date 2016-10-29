require_relative 'card'

class Tableau

  def initialize(cards = [])
    @cards = cards
    @card_taken = nil
  end

  def <<(cards)
    unless empty? || cards.first.stackable?(last) || card_taken == cards.first
      raise "card(s) cannot be stacked on this tableau"
    end
    until cards.empty? do
      @cards << cards.shift
    end
    card_taken = nil
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
    raise "cannot grab that card" unless grabbable?(index)
    @cards.slice!(index .. -1)
  end

  def count
    @cards.length
  end

  private

  attr_accessor :card_taken

end
