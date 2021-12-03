def solve(file)
    last = nil
    count = 0
    File.open(file).each do |line|
        current = line.to_i
        count += 1 if last && current > last
        last = current
    end
    count
end

puts "TEST: #{solve('test.txt')}"
puts "ANSWER: #{solve('input.txt')}"
