# Freecell

**Please read the rules of THIS VERSION of the game before proceeding**

* 45min.
    * Do not worry if you do not complete the entire assessement; do the best you can.
* Make sure to carefully check the spec files to see what methods are being used when.
* Run the specs as you solve the assessment. Try to get as many specs
  to pass as you can.
    * To run one specific spec, add `:line_number` at the end.  For example, `bundle exec rspec spec/assessment01_spec.rb:22`
    * To run all the specs, run `bundle exec rspec spec/assessment01_spec.rb` in the
      console.
    * Look at the title of the spec to see why it failed; you can also
      look at the spec code for more information.


### Special rules of this version of the game.

Pay particular attention to the special rules. There are many versions of Freecell, so make sure you understand this version.

* ANY card may be placed onto an empty tableau.
* Cards CANNOT be moved from the foundation pile.
* The cards are dealt evenly among the Tableau piles at the beginning of the game.
* A card can be moved to a FreeCell pile if the receiving pile is empty.
* A card can be moved to a Tableau pile if the top card is of the opposite color and has a value of one higher (i.e., if the top card of the pile is the Jack of clubs, we could move the ten of hearts onto the pile).
* The first card moved to a Foundation pile must be an ace of the correct suit.
* Additional cards can be moved to a Foundation pile if the card is of the correct suit and has a value one higher than the top card (i.e., if the top card of the pile is the two of hearts, we could move the three of hearts onto the pile).
* The game is won when all of the cards have been moved to the Foundation piles.
