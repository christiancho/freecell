require 'byebug'
require 'rspec'
require 'tableau'
require_relative 'card_mocks'

describe "Tableau" do

  subject(:tableau) { Tableau.new }
  generate_mocks

  context "when initializing" do
    it "begins with an empty array" do
      expect(tableau.empty?).to be true
    end

    it "can take a number of cards" do
      tableau = Tableau.new([seven_of_clubs, five_of_hearts, jack_of_diamonds])
      expect(tableau.count).to eq(3)
      expect(tableau.last.value).to eq(:jack)
    end
  end

  describe "#empty?" do
    it "returns true if the tableau is empty" do
      expect(tableau.empty?).to be true

      tableau = Tableau.new([ace_of_spades])
      expect(tableau.empty?).to be false
    end
  end

  describe "#count" do
    it "returns the correct number of cards in the tableau" do
      expect(tableau.count).to eq(0)
      tableau = Tableau.new([seven_of_clubs, five_of_hearts, jack_of_diamonds, three_of_spades])
      expect(tableau.count).to eq(4)
    end
  end

  describe "#[]" do
    it "returns the card at the index of the tableau" do
      tableau = Tableau.new([seven_of_clubs, five_of_hearts, jack_of_diamonds])
      expect(tableau[1]).to eq(five_of_hearts)
    end
  end

  describe "#last" do
    it "returns the last card in the tableau" do
      tableau.add_cards([three_of_hearts, two_of_clubs])
      expect(tableau.last.value).to eq(:two)
      expect(tableau.last.suit).to eq(:club)
    end
  end

  describe "#add_cards" do
    it "adds a card" do
      tableau.add_cards([ace_of_spades])
      expect(tableau.last).to eq(ace_of_spades)
    end

    it "adds multiple cards" do
      tableau.add_cards([king_of_hearts, queen_of_clubs, jack_of_hearts, ten_of_spades])
      expect(tableau.last).to eq(ten_of_spades)
    end

    it "raises a UserError when invalid move" do
      tableau.add_cards([ace_of_spades])
      hand = [five_of_hearts, four_of_clubs]
      # debugger
      expect do
        tableau.add_cards(hand)
      end.to raise_error(UserError, "card(s) cannot be stacked on this tableau")
    end

    it "allows cards that were taken from that tableau to be placed back" do
      tableau = Tableau.new([seven_of_clubs, five_of_hearts, jack_of_diamonds])
      hand = tableau.grab(2)
      tableau.add_cards(hand)
      expect(tableau.last).to eq(jack_of_diamonds)
    end
  end

  describe "#grabbable?" do
    it "returns true if the card and all of the cards below it can be grabbed" do
      tableau = Tableau.new([ace_of_spades, three_of_hearts, two_of_clubs])
      expect(tableau.grabbable?(1)).to be true
    end

    it "returns false if the card cannot be grabbed" do
      tableau = Tableau.new([ace_of_spades, three_of_hearts, two_of_clubs])
        expect(tableau.grabbable?(0)).to be false
    end
  end

  describe "#grab" do
    it "returns all cards at and below that location in the tableau" do
      tableau = Tableau.new([ace_of_spades, three_of_hearts, two_of_clubs])
      hand = tableau.grab(1)

      expect(hand.length).to eq(2)
      expect(hand.last).to eq(two_of_clubs)
    end

    it "removes those cards from the tableau" do
      tableau = Tableau.new([ace_of_spades, three_of_hearts, two_of_clubs])
      hand = tableau.grab(1)

      expect(tableau.last).to eq(ace_of_spades)
    end

    it "raises UserError if the card cannot be grabbed" do
      tableau = Tableau.new([ace_of_spades, three_of_hearts, two_of_clubs])
      expect{ tableau.grab(0) }.to raise_error(UserError, "cannot grab that card")
    end

  end

end
