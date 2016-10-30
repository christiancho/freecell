require 'card'

def generate_mocks

  suits = [:spade, :diamond, :club, :heart]
  values = [
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

  suits.each do |suit|
    values.each do |value|
      stub = value.to_s + "_of_" + suit.to_s + "s"
      let(stub.to_sym) { Card.new(value,suit) }
    end
  end
end
