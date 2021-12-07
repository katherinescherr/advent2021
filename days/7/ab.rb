def parse_input(file)
    initial_timers = []
    File.open(file).each do |line|
        current = line.strip
        initial_timers = current.split(",").map(&:to_i)
    end
    initial_timers
end

def rounded_median(array)
    sorted = array.sort
    len = sorted.length
    ((sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0).round
end

def rounded_average(array)
    len = array.length
    (array.sum * 1.0 / len).round
end

def solveA(file)
    initial_locations = parse_input(file)
    ideal_location = rounded_median(initial_locations)
    initial_locations.map do |location|
        (location - ideal_location).abs
    end.sum
end


def solveB(file)
    initial_locations = parse_input(file)
    avg_location = rounded_average(initial_locations)
    med_location = rounded_median(initial_locations)
    locations = [avg_location, med_location].sort
    (locations[0]..locations[1]).map do |ideal_location|
        initial_locations.map do |location|
            (0..(location - ideal_location).abs).sum
        end.sum
    end.min
end


puts "TEST A: #{solveA('test.txt')}"
puts "ANSWER A: #{solveA('input.txt')}"
puts "TEST B: #{solveB('test.txt')}"
puts "ANSWER B: #{solveB('input.txt')}"
