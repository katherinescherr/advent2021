def solve(file)
    nums = []
    count = 0
    last = nil
    File.open(file).each do |line|
        nums.append(line.to_i)
        nums.shift() if nums.length > 3
        next if nums.length < 3
        current = nums.sum()
        count += 1 if last && current > last
        last = current
    end
    count
end


puts "TEST: #{solve('test.txt')}"
puts "ANSWER: #{solve('input.txt')}"
