function repeated(instructions)
    # Initialize the position of H and T to be the same
    H_row = T_row = 0
    H_col = T_col = 0
    
    # Create a Set to store the positions T visits
    visited_positions = Set{Tuple{Int, Int}}()
    
    # Add the initial position of T to the set
    push!(visited_positions, (T_row, T_col))

    # Iterate through the instructions for H
    for instruction in instructions
        # Update the position of H according to the instruction
        direction = instruction[1]
        distance = parse(Int64, instruction[2:end])

        for i in 1:distance
            if direction == 'U'
                H_row -= 1
            elseif direction == 'D'
                H_row += 1
            elseif direction == 'L'
                H_col -= 1
            elseif direction == 'R'
                H_col += 1
            end
            
            dr = H_row - T_row
            dc = H_col - T_col
            if abs(dr) > 1 || abs(dc) > 1
                T_row += sign(dr)
                T_col += sign(dc)
            end
            
            # Add the current position of T to the set
            push!(visited_positions, (T_row, T_col))
        end
    end

    # Return the number of positions T visits
    return length(visited_positions)
end

function part_2(instructions)
    # Initialize the position of H and the knots to be the same
    knots = Vector{Tuple{Int, Int}}(undef, 10)
    for i in 1:10
        knots[i] = (0, 0)
    end

    visited_positions = Set{Tuple{Int, Int}}()
    push!(visited_positions, (0,0))
    
    # Iterate through the instructions for H
    for instruction in instructions
        # Update the position of H according to the instruction
        direction = instruction[1]
        distance = parse(Int64, instruction[2:end])

        for i in 1:distance
            H_row, H_col = knots[1]
            if direction == 'U'
                knots[1] = H_row - 1, H_col
            elseif direction == 'D'
                knots[1] = H_row + 1, H_col
            elseif direction == 'L'
                knots[1] = H_row, H_col - 1
            elseif direction == 'R'
                knots[1] = H_row, H_col + 1
            end
            
            # Update the position of the knots
            for i in 2:10
                knot_row, knot_col = knots[i]
                leader_row, leader_col = knots[i-1]
                dr = leader_row - knot_row
                dc = leader_col - knot_col
                if abs(dr) > 1 || abs(dc) > 1
                    knot_row += sign(dr)
                    knot_col += sign(dc)
                    knots[i] = (knot_row, knot_col)
                end
            end

            push!(visited_positions, knots[end])
        end
    end

    # Return the final positions of the knots
    return length(visited_positions)
end


input = cd("day09") do
    readlines("sample.txt")
end

repeated(input)

part_2(input)