def parse_input(file)
    str = File.open(file).map(&:strip).first
    x1, x2, y1, y2 = str.scan(/\-?\d+/).map(&:to_i)
    return x1, x2, y1, y2
end

def max_y(yv)
    [y_value(yv, yv), y_value(yv + 1, yv)].max
end

def y_value(n, yv)
    n * (yv + 0.5 - 0.5 * n)
end

def step(xv, yv, x, y)
    x += xv
    y += yv
    xv += xv != 0 ? (-xv/xv) : 0
    yv -= 1
    return xv, yv, x, y
end

def within_range(x, y, range_x, range_y)
    (
        x >= range_x.first &&
        x <= range_x.last &&
        y >= range_y.first &&
        y <= range_y.last
    )
end

def test_velocities(xv, yv, range_x, range_y)
    init_xv, init_yv = xv, yv
    works = false
    x, y = 0, 0
    last_diff = 0
    (1..1000).each do |n|
        xv, yv, x, y = step(xv, yv, x, y)
        works = true if within_range(x, y, range_x, range_y)
    end
    works
end

def solve(file)
    x1, x2, y1, y2 = parse_input(file)
    good_velocities = []

    # TODO: find a way to not brute force this
    (0..250).each do |xv|
        (-250..250).each do |yv|
            good_velocities << [xv, yv] if test_velocities(xv, yv, [x1, x2], [y1, y2])
        end
    end

    good_velocities
end

def solve_a(file)
    good_velocities = solve(file)
    good_velocities.map { |xv, yv| max_y(yv) }.max
end

def solve_b(file)
    good_velocities = solve(file)
    good_velocities.length
end

puts "TEST A: #{solve_a('test.txt')}"
puts "ANSWER A: #{solve_a('input.txt')}"
puts "TEST B: #{solve_b('test.txt')}"
puts "ANSWER B: #{solve_b('input.txt')}"
