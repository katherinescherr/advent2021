def parse_input(file)
    File.open(file).map do |line|
        line.strip.split("").map(&:to_i)
    end
end

class Grid
    attr_accessor :grid, :flash_count

    def initialize(grid)
        @grid = grid
        @flash_count = 0
    end

    def step
        first_flashes = []
        @grid.each_with_index do |row, i|
            row.each_with_index do |octo, j|
                @grid[i][j] += 1
                first_flashes << [i, j] if octo == 9
            end
        end
        first_flashes.each do |i,j|
            flash(i,j)
        end
        @grid.each_with_index do |row, i|
            row.each_with_index do |octo, j|
                if @grid[i][j] >= 10
                    @grid[i][j] = 0
                end
            end
        end
    end

    private


    def print_grid
        for row in @grid
            puts "#{row.join("")}"
        end
        puts ""
        puts ""
    end

    def flash(i, j)
        @flash_count += 1
        adjacent_coords(i, j).each do |ii, jj|
            @grid[ii][jj] += 1
            if @grid[ii][jj] == 10
                flash(ii,jj)
            end
        end
    end

    def adjacent_coords(i, j)
        [[i-1,j],
        [i-1,j-1],
        [i-1,j+1],
        [i+1,j],
        [i+1,j-1],
        [i+1,j+1],
        [i,j-1],
        [i,j+1]].filter do |ii,jj|
            ii >= 0 && ii < @grid.size && jj >= 0 && jj < @grid[i].size
        end
    end
end

def solve_a(file)
    grid = parse_input(file)
    grid = Grid.new(grid)
    100.times { grid.step }
    grid.flash_count
end

def solve_b(file)
    grid = parse_input(file)
    grid = Grid.new(grid)
    step = 0
    last_flashes = 0
    loop do
        grid.step
        step += 1
        break if grid.flash_count - last_flashes == 100
        last_flashes = grid.flash_count
    end
    step
end

puts "TEST A: #{solve_a('test.txt')}"
puts "ANSWER A: #{solve_a('input.txt')}"
puts "TEST B: #{solve_b('test.txt')}"
puts "ANSWER B: #{solve_b('input.txt')}"
