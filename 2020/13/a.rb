def parse_input(file)
    lines = File.open(file).map(&:strip)
    time = lines.shift.to_i
    buses = lines.shift.split(",").filter { |x| x != "x" }.map(&:to_i)
    return time, buses
end

def solve(file)
    time, buses = parse_input(file)
    waits = {}

    buses.each do |bus|
        wait = bus - (time % bus)
        waits[wait] = bus
    end

    best_wait = waits.keys.min
    best_wait * waits[best_wait]
end


puts solve("test.txt")
puts solve("input.txt")