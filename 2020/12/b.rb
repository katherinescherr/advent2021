def parse_input(file)
    dirs = []
    File.open(file).map do |line|
        current = line.strip.split("")
        dirs << [current.shift, current.join("").to_i]
    end
    dirs
end

Direction = Struct.new(:command, :amount) do
    def change(i, j, direction, way_i, way_j)
        case command
        when "N"
            way_i += amount
        when "S"
            way_i -= amount
        when "E"
            way_j += amount
        when "W"
            way_j -= amount
        when "R"
            (amount / 90).times do
                way_i, way_j= -way_j, way_i
            end
        when "L"
            (amount / 90).times do
                way_i, way_j= way_j, -way_i
            end
        when "F"
            i += way_i * amount
            j += way_j * amount
        end
        return i, j, direction, way_i, way_j
    end
end

def solve(file)
    dirs = parse_input(file)
    way_i, way_j = 1, 10
    i, j = 0, 0
    direction = "E"

    dirs.each do |command, amount|
        dir = Direction.new(command, amount)
        i, j, direction, way_i, way_j = dir.change(i, j, direction, way_i, way_j)
    end


    i.abs + j.abs
end


puts solve("test.txt")
puts solve("input.txt")