def parse_input(file)
    File.open(file).map do |line|
        line.strip.split("-")
    end
end

def find_paths(segment_map, existing_path, node)
    return if node.match(/[a-z]+/) && existing_path.include?(node)
    new_path = existing_path.clone()
    new_path << node
    return @paths << new_path if node == "end"
    segment_map[node].each do |next_node|
        find_paths(segment_map, new_path, next_node)
    end
end

def solve(file)
    @paths = []
    segments = parse_input(file)
    segment_map = {}

    segments.each do |node_a, node_b|
        segment_map[node_a] ||= []
        segment_map[node_a] << node_b
        segment_map[node_b] ||= []
        segment_map[node_b] << node_a
    end

    find_paths(segment_map, [], "start").count
    @paths.count
end

puts solve("test.txt")
puts solve("input.txt")