require_relative 'tableau'
require_relative 'cursorable'

class Board

  include Cursorable

  attr_accessor :tableaus, :hand

  attr_reader :freecells, :foundations, :message, :cursor_pos

  def initialize
    @tableaus = Array.new(8)
    @freecells = Array.new(4)
    @foundations = Array.new(4) { Array.new }
    @cursor_pos = [0,0]
    @message = ""
    @hand = []
    @old_position = nil
    setup
  end

  def render
    render_header
    print "\n"
    render_freecells
    print "".center(8)
    render_foundations
    print "\n"
    render_tableaus
    render_message
    p cursor_pos
    print "Hand "
    print hand
  end

  def lower_limit
    @tableaus.max_by(&:count).count
  end

  def won?
    @tableaus.all? { |tab| tab.empty? } && @freecells.empty?
  end

  def inspect
    render
  end

  def in_bounds?(pos)
    x, y = pos
    return false if x < 0 || y < 0 || y > 7
    return false if x > lower_limit
    true
  end

  def move!
    begin
      x, y = @cursor_pos
      if x == 0 && y <= 3
        if hand.empty?
          get_freecell(y)
        else
          place_in_freecells(y)
        end
      elsif x == 0 && y >3
        if hand.empty?
          raise "you cannot move foundation cards"
        else
          place_in_foundations(y)
        end
      else
        if hand.empty?
          get_stack(y, x + 1)
        else
          place_on_tab(y, x + 1)
        end
      end
    rescue => error
      set_message(error.message)
    end
  end

  private

  def setup
    cards = Card.all_cards
    cards.shuffle!
    temporary_tableaus = Array.new(8) { Array.new }
    index = 0
    until cards.empty? do
      temporary_tableaus[index % 8] << cards.pop
      index += 1
    end
    8.times { |num| tableaus[num] = Tableau.new(temporary_tableaus[num]) }
  end

  def get_stack(tab_num, index)
    hand = tableaus[tab_num].grab(index)
    old_position = [tab_num, index]
  end

  def place_on_tab(tab_num)
    tableaus[tab_num] << hand
    old_position = nil
  end

  def place_in_freecells(index)
    raise "invalid move" if hand.length > 1
    raise "no more freecells left" if freecells.none? { |space| space.nil? }
    card = hand.first
    freecells[index] = card
    hand = nil
  end

  def get_freecell(index)
    raise "no card there" if freecells[index].nil?
    freecells.slice!(index)
  end

  def place_in_foundations(index)
    raise "only one card at a time" if cards.length > 1
    card = hand.first
    top_card = foundations[index]
    unless (foundations[index].empty? && card.value == :ace) ||
      (top_card.value == card.value - 1 && top_card.suit == card.suit)
      raise "card cannot be placed in foundation piles"
    end
    foundations[index] << card
    hand = nil
  end

  def set_message(message)
    @message = message
  end

  def render_header
    system("clear")
    puts "".center(56,"-")
    puts "F R E E C E L L".center(56)
    puts "".center(56,"-")
    print "Freecells".center(24)
    print "".center(8)
    print "Foundations".center(24)
    print "\n"
  end

  def render_freecells
    4.times do |index|
      print " "
      element = freecells[index]
      if @cursor_pos[0] == 0 && @cursor_pos[1] == index
        render_unit(element, :yellow)
      else
        render_unit(element)
      end
      print "  "
    end
  end

  def render_foundations
    4.times do |index|
      print "  "
      element = foundations[index]
      if @cursor_pos[0] == 0 && @cursor_pos[1] == index + 4
        render_unit(element.last, :yellow)
      else
        render_unit(element.last)
      end
      print " "
    end
  end

  def render_tableaus
    x, y = cursor_pos
    print "\n"
    puts "T A B L E A U S".center(56)
    print "\n"
    longest_length = tableaus.max_by(&:count).count
    index = 0
    while index < longest_length do
      8.times do |tab_num|
        print "  "
        card = tableaus[tab_num][index]
        if tab_num == y && index + 1 == x
          render_unit(card, :yellow)
        else
          render_unit(card)
        end
        print "  "
      end
      print "\n"
      index += 1
    end
    puts "".center(56,"-")
  end

  def render_unit(card, bg_color = :white)
    if card.nil?
      print "   ".colorize(:background => bg_color)
    else
      print card.display(bg_color)
    end
  end

  def render_message
    print " Message: "
    puts @message.colorize(:light_green)
  end

end
