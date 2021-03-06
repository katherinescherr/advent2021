require 'set'

def parse_input(file)
    grid = []
    File.open(file).each do |line|
        current = line.strip
        grid << current.split("").map(&:to_i)
    end
    grid
end

def adjacent_coords(grid, i, j)
    grid_size = grid.size
    row_size = grid[i].size
    adjacent_coords = []

    if i > 0
        adjacent_coords << [i-1, j]
    end

    if i < grid_size - 1
        adjacent_coords << [i+1, j]
    end

    if j > 0
        adjacent_coords << [i, j-1]
    end

    if j < row_size - 1
        adjacent_coords << [i, j+1]
    end

    adjacent_coords
end

def test_basin(grid, set, x, y)
    adjacent_coords(grid, x, y).each do |i,j|
        point = grid[i][j]
        if point < 9 && set.add?([i,j])
            test_basin(grid, set, i, j)
        end
    end
end

def get_low_points(grid)
    low_points = []
    grid.each_with_index do |row, i|
        row.each_with_index do |point, j|
            adjacent_points = adjacent_coords(grid, i, j).map do |x, y|
                grid[x][y]
            end
            if adjacent_points.min > point
                low_points << [i,j]
            end
        end
    end
    low_points
end

def solve_a(file)
    grid = parse_input(file)
    answer = 0
    low_points = get_low_points(grid)
    low_points.each do |coords|
        answer += grid[coords[0]][coords[1]] + 1
    end
    answer
end

def solve_b(file)
    grid = parse_input(file)
    low_points = get_low_points(grid)
    basins = []
    low_points.each do |coords|
        set = Set.new([coords])
        basin = test_basin(grid, set, coords[0], coords[1])
        basins << set.size       
    end
    top_3 = basins.max(3)
    top_3[0] * top_3[1] * top_3[2]
end


puts "TEST A: #{solve_a('test.txt')}"
puts "ANSWER A: #{solve_a('input.txt')}"
puts "TEST B: #{solve_b('test.txt')}"
puts "ANSWER B: #{solve_b('input.txt')}"
