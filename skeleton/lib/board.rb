require 'byebug'
require_relative 'tableau'
require_relative 'cursorable'

class Board

  include Cursorable

  attr_reader :foundations, :freecells, :tableaus

  def initialize
    @tableaus = Array.new(8)
    @freecells = Array.new(4)
    @foundations = Array.new(4) { Array.new }
    @cursor_pos = [0,0]
    @message = ""
    @hand = []
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
    print "\n"
    show_hand
  end

  def won?
    @foundations.flatten.length == 52
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
      elsif x == 0 && y > 3
        if hand.empty?
          raise UserError.new("you cannot move foundation cards")
        else
          place_in_foundations(y - 4)
        end
      else
        if hand.empty?
          get_stack(y, x - 1)
        else
          place_on_tab(y)
        end
      end
    rescue UserError => error
      set_message(error.message)
    end
  end

  def set_message(new_message)
    @message = new_message
  end

  private

  attr_accessor :hand, :cursor_pos, :message
  attr_writer :foundations, :freecells, :tableaus

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
    @hand = tableaus[tab_num].grab(index)
    set_message("")
    cursor_pos[0] -= 1 if cursor_pos[0] > lower_limit
  end

  def in_bounds?(pos)
    x, y = pos
    x < 0 || x > lower_limit || y < 0 || y > 7 ? false : true
  end

  def lower_limit
    @tableaus.max_by(&:count).count
  end

  def place_on_tab(tab_num)
    tableaus[tab_num].add_cards(hand)
    set_message("")
  end

  def place_in_freecells(index)
    raise UserError.new("invalid move") if hand.length > 1
    raise UserError.new("freecell is taken") unless freecells[index].nil?
    raise UserError.new("no more freecells left") if freecells.none? { |space| space.nil? }
    card = hand.first
    freecells[index] = card
    @hand = []
    set_message("")
  end

  def get_freecell(index)
    raise UserError.new("no card there") if freecells[index].nil?
    @hand = [freecells[index]]
    freecells[index] = nil
    set_message("")
  end

  def place_in_foundations(index)
    raise UserError.new("only one card at a time") if hand.length > 1
    card = hand.first
    if foundations[index].empty? && card.value != :ace
      raise UserError.new("only aces can be placed in open foundation piles")
    end
    top_card = foundations[index].last
    unless (foundations[index].empty? && card.value == :ace) ||
      (top_card.num == card.num - 1 && top_card.suit == card.suit)
      raise UserError.new("card cannot be placed in that pile")
    end
    foundations[index] << card
    @hand = []
    set_message("")
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
      if cursor_pos[0] == 0 && cursor_pos[1] == index
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
      if cursor_pos[0] == 0 && cursor_pos[1] == index + 4
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
    puts message.colorize(:light_green)
  end

  def show_hand
    return if @hand.empty?
    print "Moving: "
    @hand.each do |card|
      render_unit(card)
      print " "
    end
    print "\n"
  end

end
