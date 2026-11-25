# Gemcart - a push-your-luck dice game in Ruby.
#
# You and a rival prospector race to bank 50 gems. On your turn, roll
# two dice as often as you dare: the pips add to your cart. Roll a 1 on
# either die and the cart tips - you lose everything unbanked. Type
# 'bank' to lock the cart in and end your turn. The rival plays by a
# simple rule: it banks at 15 or more.
# Commands: roll / bank / quit. Usage: ruby gemcart.rb [--seed N]

TARGET = 50
RIVAL_BANK_AT = 15

seed = 20261125
args = ARGV.dup
while (i = args.index("--seed"))
  seed = args[i + 1].to_i
  args.delete_at(i + 1)
  args.delete_at(i)
end
rng = Random.new(seed)

def take_turn(name, banked, rng, interactive, input)
  cart = 0
  loop do
    if interactive
      print "#{name}: banked #{banked}, cart #{cart}. [roll/bank] "
      $stdout.flush
      line = input.gets
      return [banked, :quit] if line.nil?
      cmd = line.strip.downcase
      return [banked, :quit] if %w[quit q].include?(cmd)
      if cmd == "bank"
        puts "#{name} banks #{cart} gems."
        return [banked + cart, :ok]
      elsif !%w[roll r].include?(cmd) && !cmd.empty?
        puts "Type 'roll' or 'bank'."
        next
      end
    else
      if cart >= RIVAL_BANK_AT
        puts "#{name} banks #{cart} gems."
        return [banked + cart, :ok]
      end
      sleep 0
    end
    d1 = rng.rand(1..6)
    d2 = rng.rand(1..6)
    if d1 == 1 || d2 == 1
      puts "#{name} rolls #{d1} and #{d2} - a die shows 1! The cart tips, #{cart} gems spill."
      return [banked, :ok]
    end
    cart += d1 + d2
    puts "#{name} rolls #{d1} and #{d2} - cart holds #{cart}."
    return [banked + cart, :win] if banked + cart >= TARGET && !interactive
  end
end

puts "=== GEMCART ==="
puts "First to bank #{TARGET} gems wins. Roll two dice to fill your cart;"
puts "a 1 on either die spills it. 'bank' locks the cart in."
puts

you = 0
rival = 0
winner = nil
until winner
  you, status = take_turn("You", you, rng, true, STDIN)
  break if status == :quit
  if you >= TARGET
    winner = "you"
    break
  end
  puts "You: #{you} banked. Rival's turn."
  rival, _ = take_turn("Rival", rival, rng, false, nil)
  if rival >= TARGET
    winner = "rival"
    break
  end
  puts "Rival: #{rival} banked. Your turn.\n\n"
end

puts "\n=== GAME OVER ==="
case winner
when "you" then puts "You bank #{you} gems and buy the mine. You win!"
when "rival" then puts "The rival banks #{rival} gems first. The mine is theirs."
else puts "Called off. You: #{you}, Rival: #{rival}."
end
