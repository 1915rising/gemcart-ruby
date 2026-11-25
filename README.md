# Gemcart (Ruby)

A push-your-luck dice game for the terminal, written in Ruby (standard
library only, no gems to install).

You and a rival prospector race to bank 50 gems. On your turn you roll
two dice as often as you dare and the pips fill your cart — but roll a
1 on either die and the cart tips, spilling everything unbanked. Bank
to lock the cart in and pass the turn. The rival banks cautiously at
15 or more, so greed is a real strategy, not just a temptation.

## Play

```sh
ruby gemcart.rb             # random game
ruby gemcart.rb --seed 42   # reproducible game (fixed dice)
```

Commands on your turn: `roll`, `bank`, `quit`.

## Tested envelope

- Runs clean on Ruby 3.3.6 with no gems beyond the standard library.
- Verified end to end with scripted stdin playthroughs on `--seed 42`:
  full games reaching the game-over screen (banking strategy and
  bust-out paths exercised), plus a quit path.
