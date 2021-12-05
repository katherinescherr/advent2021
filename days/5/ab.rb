class HVLine
    attr_reader :x1, :y1, :x2, :y2

    def initialize(x1, y1, x2, y2)
        @x1, @y1, @x2, @y2 = x1, y1, x2, y2
    end

    def diaganol?
        @diaganol ||= x_change != 0 && y_change != 0
    end

    def x_change
        @x_change ||= calc_change(x1, x2)
    end

    def y_change
        @y_change ||= calc_change(y1, y2)
    end

    def difference
        [(x1 - x2).abs, (y1 - y2).abs].max
    end

    private
    
    def calc_change(num1, num2)
        if num1 == num2
            0
        elsif num1 < num2
            1
        else
            -1
        end
    end
end

class HVGrid
    def initialize(size)
        @grid = Array.new(size) { Array.new(size, 0) }
    end

    def add_lines(lines, allow_diaganol)
        for line in lines do
            next if line.diaganol? && !allow_diaganol
            add_line(line)
        end
    end

    def count_overlaps
        @grid.flatten.filter { |num| num > 1 }.count
    end

    def print_grid
        for line in @grid
            puts "#{line.map {|i| i > 0 ? i : '.'}.join('')}"
        end
    end

    private

    def add_line(line)
        x, y = line.x1, line.y1
        for i in (0..line.difference) do
            @grid[y][x] += 1
            x += line.x_change
            y += line.y_change
        end
    end
end

def parse_input(file)
    lines = []
    max = 0
    File.open(file).each do |line|
        current = line.strip
        x1, y1, x2, y2 = line.split(/[^0-9]+/).map(&:to_i)
        max = [x1, y1, x2, y2, max].max
        lines << HVLine.new(x1, y1, x2, y2)
    end
    return lines, max
end

def solve(file, allow_diaganol = false)
    lines, max = parse_input(file)
    grid = HVGrid.new(max + 1)
    grid.add_lines(lines, allow_diaganol)
    # grid.print_grid
    grid.count_overlaps
end

def solveA(file)
    solve(file)
end

def solveB(file)
    solve(file, true)
end


puts "TEST A: #{solveA('test.txt')}"
puts "ANSWER A: #{solveA('input.txt')}"
puts "TEST B: #{solveB('test.txt')}"
puts "ANSWER B: #{solveB('input.txt')}"
