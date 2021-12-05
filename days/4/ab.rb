class BingoBoard
    def initialize(horizontals)
        @board_nums = horizontals.flatten
        @rows = Array.new(horizontals)
        add_verticals(horizontals)
    end

    def is_winner?(called_nums)
        @rows.detect do |row|
            (row & called_nums).length == row.length
        end
    end

    def get_score(called_nums, last_num)
        unselected_sum = (@board_nums - called_nums).sum
        last_num * unselected_sum
    end

    private

    def add_verticals(horizontals)
        for i in 0..horizontals.length do
            row = []
            for horizontal in horizontals do
                row << horizontal[i]
            end
            @rows << row
        end
    end
end

def parse_bingo_input(file)
    nums, boards, rows = [], [], []
    File.open(file).each_with_index do |line, i|
        current = line.strip
        if i == 0
            nums = current.split(",").map { |num| num.to_i }
            next
        end
        if current == ""
            next
        end
        row = current.split.map { |num| num.to_i }
        rows << row
        if row.length == rows.length
            boards << BingoBoard.new(rows)
            rows = []
        end
    end
    return nums, boards
end

def solveA(file)
    nums, boards = parse_bingo_input(file)
    called_nums = []
    winner = nil
    last_num = nums.find do |num|
        called_nums << num
        winner = boards.find do |board|
            true if board.is_winner?(called_nums)
        end
    end
    winner.get_score(called_nums, last_num)
end

def solveB(file)
    nums, boards = parse_bingo_input(file)
    called_nums = []
    last_winner = nil
    last_num = nums.find do |num|
        called_nums << num
        if boards.length == 1
            last_winner = boards.first
        end
        boards = boards.filter do |board|
            true unless board.is_winner?(called_nums)
        end
        last_winner if boards.empty?
    end
    last_winner.get_score(called_nums, last_num)
end


puts "TEST A: #{solveA('test.txt')}"
puts "ANSWER A: #{solveA('input.txt')}"
puts "TEST B: #{solveB('test.txt')}"
puts "ANSWER B: #{solveB('input.txt')}"
