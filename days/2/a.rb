def solve(file)
    x, y = 0, 0
    File.open(file).each do |line|
        direction, length = line.split
        length = length.to_i
        case direction
        when "forward"
            x += length
        when "down"
            y += length
        when "up"
            y -= length
        end
    end
    x * y
end

puts "TEST: #{solve('test.txt')}"
puts "ANSWER: #{solve('input.txt')}"
