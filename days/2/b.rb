def solve(file)
    x, y = 0, 0
    aim = 0
    File.open(file).each do |line|
        direction, value = line.split
        value = value.to_i
        case direction
        when "forward"
            x += value
            y += aim * value
        when "down"
            aim += value
        when "up"
            aim -= value
        end
    end
    x * y
end

puts "TEST: #{solve('test.txt')}"
puts "ANSWER: #{solve('input.txt')}"
