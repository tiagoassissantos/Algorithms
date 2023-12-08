defmodule Factorial do
  def factorial(number) do
    if number == 1 do
      1
    else
      number * factorial(number - 1)
    end
  end
end

IO.puts(Factorial.factorial(6))
