defmodule SquareRoot do
  def sqrt(number) do
    sqrt_iter(1.0, number)
  end

  def sqrt_iter(guess, number) do
    if good_enough?(guess, number) do
      guess
    else
      sqrt_iter(improve(guess, number), number)
    end
  end

  def good_enough?(guess, number) do
    abs(:math.sqrt(number) - guess) < 0.001
  end

  def improve(guess, number) do
    average(guess, number / guess)
  end

  def average(number, guess) do
    (number + guess) / 2
  end
end

IO.puts(SquareRoot.sqrt(15784562394578353435345345353535355359867763451326583675 * 8457634738654873))
