def parse_input(file)
    File.open(file).map do |line|
        line.strip.split("")
    end
end

def map_char(char)
    case char
    when ")"
        3
    when "]"
        57
    when "}"
        1197
    when ">"
        25137
    end
end

def get_illegal_chars_per_line(lines)
    lines.map do |line|
        illegal_chars = []
        char_arr = []
        line.each do |char|
            if ["{","[","<","("].include? (char)
                char_arr.push(char)
            elsif char_arr.length == 0
                illegal_chars.push(char)
            else
                legal = case char_arr.last
                when "{"
                    char == "}"
                when "<"
                    char == ">"
                when "("
                    char == ")"
                when "["
                    char == "]"
                end
                if legal
                    char_arr.pop()
                else
                    illegal_chars.push(char)
                end
            end
        end
        illegal_chars
    end
end

def solve_a(file)
    lines = parse_input(file)
    answer = 0
    get_illegal_chars_per_line(lines).each do |chars|
        if chars.length > 0
            answer += map_char(chars.first)
        end
    end
    answer
end

puts "TEST A: #{solve_a('test.txt')}"
puts "ANSWER A: #{solve_a('input.txt')}"
