def sqrt(number)
  sqrt_iter(1.0, number)
end

def sqrt_iter(guess, number)
  if good_enough?(guess, number)
    guess
  else
    sqrt_iter(improve(guess, number), number)
  end
end

def good_enough?(guess, number)
  (guess**2 - number).abs < 0.001
end

def improve(guess, number)
  average(guess, number / guess)
end

def average(number, guess)
  (number + guess) / 2
end

#puts sqrt(15784562394578353435345345353535355359867763451326583675 * 8457634738654873)
puts sqrt(0.3)