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

  context "when adding cards to a tableau" do
    describe "#<<" do
      it "adds a card" do
        tableau << [ace_of_spades]
        expect(tableau.last).to eq(ace_of_spades)
      end

      it "adds multiple cards" do
        tableau << [king_of_hearts, queen_of_clubs, jack_of_hearts, ten_of_spades]
        expect(tableau.last).to eq(ten_of_spades)
      end
    end
  end

  describe "#last" do
    it "returns the last card in the tableau" do
      tableau << [three_of_hearts, two_of_clubs]
      expect(tableau.last.value).to eq(:two)
      expect(tableau.last.suit).to eq(:club)
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

    it "raises an error if the card cannot be grabbed" do
      tableau = Tableau.new([ace_of_spades, three_of_hearts, two_of_clubs])
      expect{ tableau.grab(0) }.to raise_error("cannot grab that card")
    end

  end

end
