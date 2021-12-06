class Fish
    attr_reader :timer

    def initialize(timer = 8)
        @timer = timer
    end

    def step
        @timer -= 1
        @timer = 6 if @timer < 0
    end

    def should_create_child_next_round?
        @timer == 0
    end

    def self.create_children(count)
        Array.new(count).map do
            self.new()
        end
    end
end

class Pool
    def initialize(initial_timers)
        @counts = Array.new(9, 0)
        initial_timers.each do |timer|
            @counts[timer] += 1
        end
    end

    def step
        @counts = @counts.rotate
        @counts[6] += @counts[8]
    end

    def count
        @counts.sum
    end
end

def parse_input(file)
    initial_timers = []
    File.open(file).each do |line|
        current = line.strip
        initial_timers = current.split(",").map(&:to_i)
    end
    initial_timers
end

def solve(file, days)
    initial_timers = parse_input(file)
    pool = initial_timers.map do |timer|
        Fish.new(timer)
    end
    days.times do
        new_children = 0
        pool.each do |fish|
            new_children += 1 if fish.should_create_child_next_round?
            fish.step
        end
        pool += Fish.create_children(new_children)
    end
    pool.count
end

def solvePool(file, days)
    initial_timers = parse_input(file)
    pool = Pool.new(initial_timers)
    days.times do
        pool.step
    end
    pool.count
end

def solveA(file)
    solve(file, 80)
end

def solveB(file)
    # solve will time out here, do to exponential runtime
    solvePool(file, 256)
end


puts "TEST A: #{solveA('test.txt')}"
puts "ANSWER A: #{solveA('input.txt')}"
puts "TEST B: #{solveB('test.txt')}"
puts "ANSWER B: #{solveB('input.txt')}"
