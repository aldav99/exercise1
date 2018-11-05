h=(10..100).to_a.reject! { |e| e % 5 != 0  }
puts h