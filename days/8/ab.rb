class Segment
    attr_reader :char, :mapped_char
    attr_accessor :count

    def initialize(char)
        @char = char
        @count = 0
    end

    def set_mapped(one, four)
        @mapped_char = case count
        when 4
            "e"
        when 6
            "b"
        when 9
            "f"
        when 8
            (one.include? @char) ? "c" : "a"
        when 7
            (four.include? @char) ? "d" : "g"
        end
    end
end

class Number
    attr_reader :value

    def initialize(string, segment_maps)
        @string = string
        @segment_maps = segment_maps
        @value = get_value
    end

    def get_value
        translated_chars = @string.split("").map do |char|
            @segment_maps[char].mapped_char
        end
        sorted_str = translated_chars.sort.join("")
        case sorted_str
        when "abcefg"
            0
        when "cf"
            1
        when "acdeg"
            2
        when "acdfg"
            3
        when "bcdf"
            4
        when "abdfg"
            5
        when "abdefg"
            6
        when "acf"
            7
        when "abcdefg"
            8
        when "abcdfg"
            9
        end
    end
end


class Display
    def initialize(patterns, output)
        @patterns = patterns
        @output = output
    end

    def ones
        @output.select { |digit| digit.length == 2 }.count
    end

    def fours
        @output.select { |digit| digit.length == 4 }.count
    end

    def sevens
        @output.select { |digit| digit.length == 3 }.count
    end

    def eights
        @output.select { |digit| digit.length == 7 }.count
    end

    def solve
        segments = {}
        "abcdefg".split("").each do |char|
            segments[char] = Segment.new(char)
        end

        one, four = nil, nil
        @patterns.each do |pattern|
            if pattern.length == 2
                one = pattern
            elsif pattern.length == 4
                four = pattern
            end
            pattern.split("").each do |char|
                segments[char].count += 1
            end
        end

        segments.each do |char, segment|
            segment.set_mapped(one, four)
        end

        str_val = ""
        @output.each do |output|
            str_val += Number.new(output, segments).value.to_s
        end
        str_val.to_i
    end

    private

    def select_patterns(num)
        @patterns.select { |digit| digit.length == num }
    end
end




def parse_input(file)
    File.open(file).map do |line|
        current = line.strip
        patterns = current.split(" | ").first.split(" ")
        output = current.split(" | ").last.split(" ")
        Display.new(patterns, output)
    end
end

def solveA(file)
    displays = parse_input(file)
    answer = 0
    displays.each do |display|
        answer += display.ones
        answer += display.fours
        answer += display.sevens
        answer += display.eights
    end
    answer
end

def solveB(file)
    displays = parse_input(file)
    displays.map do |display|
        display.solve
    end.sum
end


puts "TEST A: #{solveA('test.txt')}"
puts "ANSWER A: #{solveA('input.txt')}"
puts "TEST B: #{solveB('test.txt')}"
puts "ANSWER B: #{solveB('input.txt')}"
