def factorial(number)
  fact_iter(1, 1, number)
end

def fact_iter(product, counter, max_count)
  if counter > max_count
    product
  else
    fact_iter(counter * product, counter + 1, max_count)
  end
end

puts factorial(6)