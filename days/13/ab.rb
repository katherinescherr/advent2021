Oragami = Struct.new(:dot_coords, :folds, :max_x, :max_y)

def parse_input(file)
    coords = []
    folds = []
    x_s = []
    y_s = []

    File.open(file).each do |line|
        current = line.strip
        vals = current.split(",")
        if vals.length == 2
            vals = vals.map(&:to_i)
            coords.push(vals)
            y_s.push(vals.last)
            x_s.push(vals.first)
        elsif current == ""
            next
        else
            fold = current.match(/(x|y)=(\d+)/).captures
            fold[1] = fold[1].to_i
            folds << fold
        end
    end


    Oragami.new(coords, folds, x_s.max, y_s.max)
end

def count_dots(grid)
    count = 0
    grid.each do |row|
        row.each do |dot|
            count += 1 if dot > 0
        end
    end
    count
end

def get_print_grid(grid)
    grid.map do |row|
        row.map do |num|
            num > 0 ? "#" : "."
        end.join("")
    end
end

def fold_y(grid, y)
    sub_grid = grid[y+1..-1].reverse
    start = y - sub_grid.length
    (start...y).each do |row_num|
        sub_grid[row_num].each_with_index do |dot, index|
            sub_grid[row_num][index] += grid[row_num][index]
        end
    end
    sub_grid
end

def fold_x(grid, x)
    sub_grid = []
    grid.each do |row|
        sub_grid << row[x+1..-1].reverse
    end
    sub_grid.each_with_index do |row, index|
        start = x - sub_grid.first.length
        (start...x).each do |col_num|
            sub_grid[index][col_num] += grid[index][col_num]
        end
    end
    sub_grid
end

def solve_a(file)
    oragami = parse_input(file)
    grid = Array.new(oragami.max_y + 1) { Array.new(oragami.max_x + 1, 0) }
    oragami.dot_coords.each do |x,y|
        grid[y][x] = 1
    end

    type, val = oragami.folds.first
    
    if type == "x"
        grid = fold_x(grid, val)
    else
        grid = fold_y(grid, val)
    end
    

    count_dots(grid)
end

def solve_b(file)
    oragami = parse_input(file)
    grid = Array.new(oragami.max_y + 1) { Array.new(oragami.max_x + 1, 0) }
    oragami.dot_coords.each do |x,y|
        grid[y][x] = 1
    end

    oragami.folds.each do |type, val|
        if type == "x"
            grid = fold_x(grid, val)
        else
            grid = fold_y(grid, val)
        end
    end
    
    get_print_grid(grid)
end

puts solve_a("test.txt")
puts solve_a("input.txt")
puts solve_b("test.txt")
puts solve_b("input.txt")
