def parse_input(file)
    grid = []
    File.open(file).each do |line|
        current = line.strip
        grid << current.split("").map(&:to_i)
    end
    grid
end

def make_adjacent_grid(grid, adjust_by)
    new_grid = Array.new(grid.length) { Array.new(0, grid.length) }
    grid.each_with_index do |row, i|
        row.each_with_index do |risk, j|
            new_risk = risk
            adjust_by.times do
                new_risk = (new_risk + 1) % 10
                new_risk = 1 if new_risk == 0
            end
            new_grid[i][j] = new_risk
        end
    end
    new_grid
end

def make_big_grid(risk_grid)
    big_grid = make_adjacent_grid(risk_grid, 0)

    for x in (1..4) do
        new_grid = make_adjacent_grid(risk_grid, x)

        big_grid.each_with_index do |row, i|
            row.concat(new_grid[i])
        end
    end

    row_two = make_adjacent_grid(big_grid, 1)
    row_three = make_adjacent_grid(big_grid, 2)
    row_four = make_adjacent_grid(big_grid, 3)
    row_five = make_adjacent_grid(big_grid, 4)

    big_grid += row_two + row_three + row_four + row_five
end

def traverse_path(path_risk, path_risk_grid, risk_grid, i, j)
    Proc.new {
        travers_path_proc(path_risk, path_risk_grid, risk_grid, i, j)
    }
end

def travers_path_proc(path_risk, path_risk_grid, risk_grid, i, j)
    return if i > risk_grid.length - 1 || j > risk_grid.length - 1 || i < 0 || j < 0
    path_risk += risk_grid[i][j]
    return if path_risk_grid[i][j] && path_risk >= path_risk_grid[i][j]
    path_risk_grid[i][j] = path_risk

    @func_heap << traverse_path(path_risk, path_risk_grid, risk_grid, i + 1, j)
    @func_heap << traverse_path(path_risk, path_risk_grid, risk_grid, i - 1, j)
    @func_heap << traverse_path(path_risk, path_risk_grid, risk_grid, i, j + 1)
    @func_heap << traverse_path(path_risk, path_risk_grid, risk_grid, i, j - 1)
end

def solve(file, should_make_big_grid)
    risk_grid = parse_input(file)

    risk_grid = make_big_grid(risk_grid) if should_make_big_grid

    path_risk_grid = Array.new(risk_grid.length) { Array.new(0, risk_grid.length) }

    @func_heap = [traverse_path(0, path_risk_grid, risk_grid, 0, 0)]

    loop do
        break if @func_heap.length == 0
        @func_heap.length.times do
            @func_heap.shift.call
       end
    end

    path_risk_grid.last.last - path_risk_grid.first.first
end

def solve_a(file)
    solve(file, false)
end

def solve_b(file)
    solve(file, true)
end

puts "TEST A: #{solve_a('test.txt')}"
puts "ANSWER A: #{solve_a('input.txt')}"
puts "TEST B: #{solve_b('test.txt')}"
puts "ANSWER B: #{solve_b('input.txt')}"
