def solve(file)
    answer_arr = nil
    File.open(file).each do |line|
        values = line.strip.split('').map { |bit| bit.to_i }
        unless answer_arr
            answer_arr = Array.new(values.length, 0)
        end
        values.each_with_index do |value, i|
            if value == 0
                answer_arr[i] -= 1
            else
                answer_arr[i] += 1
            end
        end
    end
    answer_str = ""
    bitmask = ""
    answer_arr.each do |value|
        if value > 0
            answer_str += "1"
        else
            answer_str += "0"
        end
        bitmask += "1"
    end
    answer_str.to_i(2) * (answer_str.to_i(2) ^ bitmask.to_i(2))
end

puts "TEST: #{solve('test.txt')}"
puts "ANSWER: #{solve('input.txt')}"
