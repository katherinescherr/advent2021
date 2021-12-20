def parse_input(file)
    lines = File.open(file).map(&:strip)

    algo = lines.shift
    lines.shift # blank line

    grid = lines.map do |line|
        line.chars
    end

    return algo, grid
end

def pad_grid(grid, round, algo)
    char = "."
    if algo[0] == "#" && round % 2 == 1
        char = "#"
    end

    new_grid = grid.map do |line|
        [char,char,char,char] + line + [char,char,char,char]
    end

    new_grid = (
        [
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char)
        ] + 
        new_grid +
        [
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char),
            Array.new(new_grid.first.length, char)
        ] 
    )
end

def trim_grid(grid)
    grid[1..-2].map do |line|
        line[1..-2]
    end
end

def clone_grid(grid)
    grid.map do |line|
        line.map do |pixel|
            pixel
        end
    end
end

def get_pixel(algo, grid, i, j)
    binary_num = (
        (grid[i-1][j-1] == "#" ? "1" : "0") +
        (grid[i-1][j] == "#" ? "1" : "0") + 
        (grid[i-1][j+1] == "#" ? "1" : "0") + 
        (grid[i][j-1] == "#" ? "1" : "0") + 
        (grid[i][j] == "#" ? "1" : "0") + 
        (grid[i][j+1] == "#" ? "1" : "0") + 
        (grid[i+1][j-1] == "#" ? "1" : "0") + 
        (grid[i+1][j] == "#" ? "1" : "0") + 
        (grid[i+1][j+1] == "#" ? "1" : "0")
    )
    index = binary_num.to_i(2)
    algo[index]
end

def count_lit_pixels(grid)
    count = 0

    grid.each do |line|
        line.each do |pixel|
            count += 1 if pixel == "#"
        end
    end

    count
end

def solve(file)
    algo, grid = parse_input(file)

    (0...50).each do |round|
        grid = pad_grid(grid, round, algo)
        answer_grid = clone_grid(grid)

        grid[1..-1].each_with_index do |line, i|
            line[1..-1].each_with_index do |pixel, j|
                answer_grid[i][j] = get_pixel(algo, grid, i, j)
            end
        end

        grid = trim_grid(answer_grid)
    end

    count_lit_pixels(grid)
end

puts solve("input.txt")