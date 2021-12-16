def parse_input(file)
    File.open(file).map(&:strip).first
end

CHAR_MAP = {
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111"
}

PacketSolver = Struct.new(:versions, :value, :index)

def solve_literal(bin_line)
    val_str = ""
    loop do
        val_str += bin_line[@index + 1..@index + 4]
        break if bin_line[@index] == "0"
        @index += 5
    end
    @index += 5
    val_str.to_i(2)
end

def solve_packet(bin_line)
    sub_packets = []
    version = bin_line[@index..@index + 2].to_i(2)
    @index += 3
    type = bin_line[@index..@index + 2].to_i(2)
    @index += 3

    @versions << version

    if type != 4
        length_type_id = bin_line[@index].to_i
        @index += 1
        if length_type_id == 0
            length = bin_line[@index...@index + 15].to_i(2)
            @index += 15
            end_index = @index + length
            loop do
                break if @index >= end_index
                sub_packets << solve_packet(bin_line)
            end
        else
            packet_num = bin_line[@index...@index + 11].to_i(2)
            @index += 11
            packet_num.times do
                sub_packets << solve_packet(bin_line)
            end
        end
    end

    case type
    when 4
        solve_literal(bin_line)
    when 0
        sub_packets.sum
    when 1
        sub_packets.reduce(:*)
    when 2
        sub_packets.min
    when 3
        sub_packets.max
    when 5
        sub_packets.first > sub_packets.last ? 1 : 0
    when 6
        sub_packets.first < sub_packets.last ? 1 : 0
    when 7
        sub_packets.first == sub_packets.last ? 1 : 0
    end
end

def to_binary(hex)
    bin_line = ""
    hex.chars.each do |char|
        bin_line += CHAR_MAP.dig(char)
    end
    bin_line
end

def solve(file)
    hex_input = parse_input(file)
    bin_string = to_binary(hex_input)

    @versions = []
    @index = 0

    solve_packet(bin_string)
end

def solve_a(file)
    solve(file)

    @versions.sum
end

def solve_b(file)
    solve(file)
end

puts "TEST A: #{solve_a('test.txt')}"
puts "ANSWER A: #{solve_a('input.txt')}"
puts "TEST B: #{solve_b('test.txt')}"
puts "ANSWER B: #{solve_b('input.txt')}"
