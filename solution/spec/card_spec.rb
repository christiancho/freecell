require 'rspec'
require 'card'
require_relative 'card_mocks'

describe "Card" do

  generate_mocks

  context "when creating a new instance" do
    it "takes a value and a suit" do
      expect(ace_of_spades.value).to eq(:ace)
      expect(ten_of_hearts.suit).to eq(:heart)
    end
  end

  describe "#num" do
    it "returns an integer value" do
      expect(ace_of_spades.num).to eq(1)
      expect(four_of_clubs.num).to eq(4)
      expect(ten_of_hearts.num).to eq(10)
      expect(queen_of_diamonds.num).to eq(12)
    end
  end

  describe "Card::all_cards" do
    it "creates all 52 cards" do
      cards = Card.all_cards
      suits = cards.map(&:suit)
      values = cards.map(&:value)
      suits.each do |suit|
        expect(suits.count(suit)).to eq(13)
      end
      values.each do |value|
        expect(values.count(value)).to eq(4)
      end
    end
  end

  describe "#to_s" do
    it "prints the value and suit" do
      expect(ace_of_spades.to_s).to eq("A♠")
      expect(four_of_clubs.to_s).to eq("4♣")
      expect(ten_of_hearts.to_s).to eq("10♥")
      expect(queen_of_diamonds.to_s).to eq("Q♦")
    end
  end

  describe "#stackable?(card)" do
    it "returns true if card can be stacked on top of valid card" do
      expect(ten_of_hearts.stackable?(jack_of_clubs)).to be true
    end

    it "returns false if card cannot be stacked on top of valid card" do
      expect(ten_of_hearts.stackable?(nine_of_spades)).to be false
    end

    it "raises an error if called on a king card" do
      expect do
        king_of_hearts.stackable?(ace_of_spades)
      end.to raise_error(UserError, "card is a king")
    end
  end

end
