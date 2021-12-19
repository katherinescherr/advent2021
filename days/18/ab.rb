require 'json'

def parse_input(file)
    File.open(file).map do |line|
        JSON.parse(line)
    end
end

def add(node_1, node_2)
    new_node = Node.new(nil, node_1, node_2)
    node_1.parent = new_node
    node_2.parent = new_node

    new_node.reduce
    new_node
end

Node = Struct.new(:parent, :left, :right, :value) do
    # for testing
    def to_s
        str = ""
        if left && right
            str += "[" + left.to_s + "," + right.to_s + "]"
        else
            str += value.to_s
        end
        str
    end

    def magnitude
        if value
            value
        else
            3 * left.magnitude + 2 * right.magnitude
        end
    end

    def leafs
        leafs = []
        add_leafs(self, 0, leafs)
        leafs
    end

    def reduce
        loop do
            first_left = leafs.find_index { |leaf| leaf.depth == 5 }

            if first_left
                explode(first_left)
                next
            end

            first_left = leafs.find_index { |leaf| leaf.node.value >= 10 }

            if first_left
                split(first_left)
            else
                break
            end
        end
    end

    private

    def add_leafs(node, depth, leafs)
        if node.left
            add_leafs(node.left, depth + 1, leafs)
            add_leafs(node.right, depth + 1, leafs)
        else
            leafs << Leaf.new(depth, node)
        end
    end

    def explode(first_left)
        left_node = leafs[first_left].node
        right_node = leafs[first_left + 1].node

        if first_left != 0
            leafs[first_left - 1].node.value += left_node.value
        end

        if first_left <= leafs.length - 3
            leafs[first_left + 2].node.value += right_node.value
        end

        node = left_node.parent
        node.left = nil
        node.right = nil
        node.value = 0
    end

    def split(first_left)
        first_left_node = leafs[first_left].node
        first_left_node.left = Node.new(first_left_node, nil, nil, (first_left_node.value / 2.0).floor)
        first_left_node.right = Node.new(first_left_node, nil, nil, (first_left_node.value / 2.0).ceil)
        first_left_node.value = nil
    end
end

Leaf = Struct.new(:depth, :node)


def create_leafs(array, parent)
    node = Node.new(parent)
    if array.is_a? Array
        node.left = create_leafs(array[0], node)
        node.right = create_leafs(array[1], node)
    elsif
        node.value = array
    end
    node
end

def create_node(line)
    top_node = create_leafs(line, nil)
    top_node
end

def solve_a(file)
    lines = parse_input(file)

    last_node = nil
    lines.each do |line|
        node = create_node(line)
        if last_node
            last_node = add(last_node, node)
        else
            last_node = node
        end
    end

    last_node.magnitude
end

def solve_b(file)
    lines = parse_input(file)
    magnitudes = []
    lines.each_with_index do |line_1, i|
        lines.each_with_index do |line_2, j|
            next if i == j
            a = create_node(line_1)
            b = create_node(line_2)
            magnitudes << add(a, b).magnitude
        end
    end

    magnitudes.max
end

puts "TEST A: #{solve_a('test.txt')}"
puts "ANSWER A: #{solve_a('input.txt')}"
puts "TEST B: #{solve_b('test.txt')}"
puts "ANSWER B: #{solve_b('input.txt')}"