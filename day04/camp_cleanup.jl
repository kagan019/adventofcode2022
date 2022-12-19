function part_one()
    # read the input file
    input_str = cd("day04") do
        read("input.txt", String)
    end

    # split the input string into an array of assignment pairs
    assignment_pairs = split(input_str, "\n")

    # initialize a counter for the number of assignment pairs where one range fully contains the other
    num_fully_contained_pairs = 0

    # loop through each assignment pair
    for pair=assignment_pairs
        # split the pair into two assignments
        assignments = split(pair, ",")
        
        # split each assignment into start and end sections
        start_section_1, end_section_1 = split(assignments[1], "-")
        start_section_2, end_section_2 = split(assignments[2], "-")
        
        # convert start and end sections to integers
        start_section_1, end_section_1 = parse(Int64, start_section_1), parse(Int64, end_section_1)
        start_section_2, end_section_2 = parse(Int64, start_section_2), parse(Int64, end_section_2)
        
        # check if one range fully contains the other
        if (start_section_1 <= start_section_2) && (end_section_1 >= end_section_2)
            num_fully_contained_pairs += 1
        elseif (start_section_2 <= start_section_1) && (end_section_2 >= end_section_1)
            num_fully_contained_pairs += 1
        end
    end

    num_fully_contained_pairs
end
part_one()
function part_two()
    # read the input file
    input_str = cd("day04") do
        read("input.txt", String)
    end
    # split the input string into an array of assignment pairs
    assignment_pairs = split(input_str, "\n")

    # initialize a counter for the number of assignment pairs that overlap
    num_overlapping_pairs = 0

    # loop through each assignment pair
    for pair in assignment_pairs
        # split the pair into two assignments
        assignments = split(pair, ",")
        
        # split each assignment into start and end sections
        start_section_1, end_section_1 = split(assignments[1], "-")
        start_section_2, end_section_2 = split(assignments[2], "-")
        
        # convert start and end sections to integers
        start_section_1, end_section_1 = parse(Int64, start_section_1), parse(Int64, end_section_1)
        start_section_2, end_section_2 = parse(Int64, start_section_2), parse(Int64, end_section_2)
        
        # check if the ranges overlap
        if (start_section_1 <= end_section_2) && (end_section_1 >= start_section_2)
            num_overlapping_pairs += 1
        elseif (start_section_2 <= end_section_1) && (end_section_2 >= start_section_1)
            num_overlapping_pairs += 1
        end
    end

    # print the result
    num_overlapping_pairs
end
part_two()