def solve(file)
    answer_arr = nil
    oxy = []
    co2 = []
    File.open(file).each do |line|
        bin = line.strip
        values = bin.split('').map { |bit| bit.to_i }
        unless answer_arr
            answer_arr = Array.new(values.length) { {"0": [], "1": []} }
        end
        values.each_with_index do |value, i|
            if value == 0
                answer_arr[i][:"0"] << bin
            else
                answer_arr[i][:"1"] << bin
            end
        end
        oxy.push(bin)
        co2.push(bin)
    end

    
    oxy_val = nil
    co2_val = nil
    answer_arr.each do |obj|
        if (oxy & obj[:"1"]).length >= (oxy & obj[:"0"]).length
            oxy = oxy & obj[:"1"]
        else
            oxy = oxy & obj[:"0"]
        end
        if (co2 & obj[:"1"]).length >= (co2 & obj[:"0"]).length
            co2 = co2 & obj[:"0"]
        else
            co2 = co2 & obj[:"1"]
        end
        if oxy.length == 1
            oxy_val = oxy.pop
        end
        if co2.length == 1
            co2_val = co2.pop
        end
    end
    oxy_val.to_i(2) * co2_val.to_i(2)
end

puts "TEST: #{solve('test.txt')}"
puts "ANSWER: #{solve('input.txt')}"
