def parse_input(file)
    File.open(file).map do |line|
        line.strip.split("")
    end
end

def map_char(char)
    case char
    when ")"
        1
    when "]"
        2
    when "}"
        3
    when ">"
        4
    end
end

def get_complete_chars_by_line(lines)
    lines.map do |line|
        char_arr = []
        legal_line = true
        line.each do |char|
            if ["{","[","<","("].include? (char)
                char_arr.push(char)
            elsif char_arr.length == 0
                legal_line = false
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
                    legal_line = false
                end
            end
        end
        if legal_line
            char_arr.map do |char|
                case char
                when "{"
                    "}"
                when "<"
                    ">"
                when "("
                    ")"
                when "["
                    "]"
                end
            end.reverse
        else
            []
        end
    end
end

def solve_b(file)
    lines = parse_input(file)
    answers = []
    get_complete_chars_by_line(lines).each do |chars|
        score = 0
        chars.each do |char|
            score = (score * 5) + map_char(char)
        end
        answers << score if score > 0
    end
    index = (answers.count - 1)/2
    answers.sort[index]
end

puts "TEST B: #{solve_b('test.txt')}"
puts "ANSWER B: #{solve_b('input.txt')}"
