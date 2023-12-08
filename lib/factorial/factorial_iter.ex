defmodule Factorial.FactorialIter do
  def factorial(number) do
    factorial_iter(1, 1, number)
  end

  def factorial_iter(product, counter, max_count) do
    if counter > max_count do
      product
    else
      factorial_iter(product * counter, counter + 1, max_count)
    end
  end
end

IO.puts(Factorial.FactorialIter.factorial(6))
