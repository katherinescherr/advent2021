# This code is a hot mess but it works  ¯\_(ツ)_/¯

def parse_input(file)
    scanner = nil
    scanners = []
    File.open(file).each do |line|
        current = line.strip
        if match = current.match(/scanner (\d+)/)
            scanner = Scanner.new(match.captures.first.to_i, [])
        elsif current == ""
            scanners << scanner
        else
            x, y, z = current.split(",").map(&:to_i)
            scanner.beacons << Beacon.new(x, y, z)
        end
    end
    scanners << scanner
    scanners
end


Scanner = Struct.new(:number, :beacons)
Beacon = Struct.new(:x, :y, :z) do
    def get_relative(beacon)
        [x-beacon.x, y-beacon.y, z-beacon.z]
    end

    def get_relative_manhattan(beacon)
        (x-beacon.x).abs + (y-beacon.y).abs + (z-beacon.z).abs
    end

    def distance
        x**2 + y**2 + z**2
    end

    def get_relative_distances(scanner)
        scanner.beacons.map do |beacon|
            get_relative(beacon).map{ |x| x**2 }.sum
        end
    end
end

MapperSet = Struct.new(:x_mapper, :y_mapper, :z_mapper) do
    def mapped_beacon(beacon)
        new_beacon = Beacon.new
        new_beacon[x_mapper.axis] = x_mapper.direction * beacon.x
        new_beacon[y_mapper.axis] = y_mapper.direction * beacon.y
        new_beacon[z_mapper.axis] = z_mapper.direction * beacon.z
        new_beacon
    end

    # needs more work
    def valid_mapper?
        (
            x_mapper.axis && y_mapper.axis && z_mapper.axis &&
            [x_mapper.axis, y_mapper.axis, z_mapper.axis].uniq.length == 3
        )
    end
end
Mapper = Struct.new(:direction, :axis) do
    def self.find_mapper(value, mapped_dir)
        mapper = self.new
        if (index = mapped_dir.index(value)) != nil
            mapper.direction = 1
            mapper.axis = case index
                when 0 then :x
                when 1 then :y
                when 2 then :z
            end
        elsif (index = mapped_dir.index(-1 * value)) != nil
            mapper.direction = -1
            mapper.axis = case index
                when 0 then :x
                when 1 then :y
                when 2 then :z
            end
        end
        mapper
    end
end

Transform = Struct.new(:mapper,:x,:y,:z) do
    def transform_beacons(beacons)
        beacons.map do |beacon|
            new_beacon = mapper.mapped_beacon(beacon)
            new_beacon.x += x
            new_beacon.y += y
            new_beacon.z += z
            new_beacon
        end
    end
end

def find_mappers(relative, relatives)
    mapper_sets = []
    for compare in relatives
        mapper_set = MapperSet.new
        mapper_set.z_mapper = Mapper.find_mapper(relative.last, compare)
        mapper_set.y_mapper = Mapper.find_mapper(relative[1], compare)
        mapper_set.x_mapper = Mapper.find_mapper(relative.first, compare)
        mapper_sets << mapper_set if mapper_set.valid_mapper?
    end
    mapper_sets
end

def find_relatives_and_mappers(scanner_a, anchor_beacon_a, scanner_b, anchor_beacon_b)
    mappers = []
    relatives = []
    for beacon in scanner_a.beacons
        next if beacon == anchor_beacon_a
        relatives << anchor_beacon_a.get_relative(beacon)
    end

    for beacon in scanner_b.beacons
        next if beacon == anchor_beacon_b
        relative = anchor_beacon_b.get_relative(beacon)
        mappers.concat(find_mappers(relative, relatives))
    end

    mappers.uniq
end


def overlap?(scanner_a, scanner_b)
    chosen_anchor_a, chosen_anchor_b = nil, nil
    mappers = []
    # using beacons as 0,0,0 instead of scanners allows you to find overlapping relative distances / points
    # use different beacon combos to find which ones have overlap
    scanner_a.beacons.each do |anchor_a|
        scanner_b.beacons.each do |anchor_b|
            # use relative distances as a short cut to find possible matches
            distances_a = anchor_a.get_relative_distances(scanner_a)
            distances_b = anchor_b.get_relative_distances(scanner_b)
            if (distances_a & distances_b).length > 10
                a_b_mappers = find_relatives_and_mappers(scanner_a, anchor_a, scanner_b, anchor_b)
                if a_b_mappers && a_b_mappers.first
                    chosen_anchor_a = anchor_a
                    chosen_anchor_b = anchor_b
                    mappers = a_b_mappers
                end
            end
        end
    end

    return false unless mappers.first

    # we have some potential maps between these two scanners, and have chosen two equivalent points (chosen_anchor a and b)
    # transform all beacons relative to anchor a for scanner a
    relatives = []
    for beacon in scanner_a.beacons
        next if beacon == chosen_anchor_a
        relatives << chosen_anchor_a.get_relative(beacon)
    end

    # transform all beacons in scanner b based on our possible mappers and chosen anchor
    mapper = mappers.find do |mapper|
        # map all scanner b beacons using possible map
        mapped_beacons = scanner_b.beacons.map do |beacon|
            next if beacon == chosen_anchor_b
            mapper.mapped_beacon(beacon)
        end.compact

        # map anchor beacon as well
        anchor_beacon_mapped = mapper.mapped_beacon(chosen_anchor_b)
        mapped_relatives = []
        # all beacons are transformed, now lets make them rel to anchor
        for beacon in mapped_beacons
            mapped_relatives << anchor_beacon_mapped.get_relative(beacon)
        end

        # test actual transform method, make sure we still have overlap
        (mapped_relatives & relatives).length > 10
    end

    return false unless mapper

    # anchors are same beacon, find difference and return to make transform
    mapped_anchor_b = mapper.mapped_beacon(chosen_anchor_b)
    x, y, z = chosen_anchor_a.get_relative(mapped_anchor_b)

    return mapper, x, y, z
end

def map_key(keys, key, to_zero_map, scanners_map)
    new_keys = scanners_map[key] - to_zero_map.keys
    new_keys.each do |new_key|
        to_zero_map[new_key] = keys
        list = keys.clone
        list << new_key
        map_key(list, new_key, to_zero_map, scanners_map)
    end
end

def solve(file)
    scanners = parse_input(file)
    scanners_map = {}
    transform_map = {}

    # for all scanner combos, find overlaps
    scanners.each_with_index do |scanner_a, i|
        scanners[i+1..-1].each do |scanner_b|
            if (mapper, x, y, z = overlap?(scanner_a, scanner_b))
                # save which scanners can map to which
                scanners_map[scanner_a.number] ||= []
                scanners_map[scanner_a.number] << scanner_b.number
                scanners_map[scanner_b.number] ||= []
                scanners_map[scanner_b.number] << scanner_a.number

                transform_a = Transform.new(mapper, x, y, z)
                # map the opposite way as well
                mapper, x, y, z = overlap?(scanner_b, scanner_a)
                transform_b = Transform.new(mapper, x, y, z)

                # save transforms in an easy to access way
                transform_map[scanner_a.number] ||= {}
                transform_map[scanner_a.number][scanner_b.number] = transform_a
                transform_map[scanner_b.number] ||= {}
                transform_map[scanner_b.number][scanner_a.number] = transform_b
            end
        end
    end

    to_zero_map = {}
    to_zero_map[0] = []

    # recursively find how to get each scanner mapped to scanner 0
    map_key([0], 0, to_zero_map, scanners_map)

    all_beacons = []
    mapped_scanners = []

    # transform beacon coords for each scanner until it is mapped onto scanner 0 grid
    scanners.each do |scanner|
        beacons = scanner.beacons
        key_things = [scanner.number].concat(to_zero_map[scanner.number].reverse)
        key_a = key_things.first
        # transform scanner as well to get relative distance to other scanners for part B
        scanner_beacons = [Beacon.new(0,0,0)]
        key_things[1..-1].each do |key_b|
            transform = transform_map[key_b][key_a]
            beacons = transform.transform_beacons(beacons)
            scanner_beacons = transform.transform_beacons(scanner_beacons) # part b
            key_a = key_b
        end
        mapped_scanners.concat(scanner_beacons) # part b
        all_beacons.concat(beacons)
    end
    
    # PART A
    all_beacons.uniq.count

    # PART B
    mapped_scanners.map do |beacon_1|
        mapped_scanners.map do |beacon_2|
            beacon_1.get_relative_manhattan(beacon_2)
        end.max
    end.max
end

puts solve("test.txt")
puts solve("input.txt")