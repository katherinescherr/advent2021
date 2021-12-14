def parse_input(file)
    template = ""
    rules = {}

    File.open(file).each do |line|
        current = line.strip
        vals = current.split(" -> ")
        if vals.length == 2
            rules[vals.first] = vals.last
        elsif current == ""
            next
        else
            template = current
        end
    end

    return template, rules
end

def initial_pairs(template, rules)
    pairs = {}
    rules.each do |pair, _|
        pairs[pair] = 0
    end
    template.scan(/(?=(.{2}))/).flatten.each do |pair|
        pairs[pair] += 1
    end
    pairs
end

def step(pairs, rules)
    new_pairs = pairs.clone
    pairs.each do |pair, value|
        new_pairs[pair] -= value
        new_pairs[pair.chars.first + rules[pair]] += value
        new_pairs[rules[pair] + pair.chars.last] += value
    end
    new_pairs
end

def solve(file, steps)
    template, rules = parse_input(file)
    pairs = initial_pairs(template, rules)

    steps.times do
        pairs = step(pairs, rules)
    end

    char_counts = {}

    # add first and last characters since they only are in 1 pair
    char_counts[template.chars.first] = 1
    char_counts[template.chars.last] ||= 0
    char_counts[template.chars.last] += 1

    # add character counts for each pair
    pairs.each do |pair, value|
        char_counts[pair.chars.first] ||= 0
        char_counts[pair.chars.first] += value
        char_counts[pair.chars.last] ||= 0
        char_counts[pair.chars.last] += value
    end

    # divide by two to get real count in string
    (char_counts.values.max - char_counts.values.min) / 2
end

def solve_a(file)
    solve(file, 10)
end

def solve_b(file)
    solve(file, 40)
end

puts solve_a("test.txt")
puts solve_a("input.txt")
puts solve_b("test.txt")
puts solve_b("input.txt")