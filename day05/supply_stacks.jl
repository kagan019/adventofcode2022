using Base.Iterators

const Stack = Vector{Char}



# Read the input file into a string array
input_lines = cd("day05") do
    readlines("input.txt")
end

# Partition the input lines into groups of 4 characters
partitioned_lines = map(input_lines) do ln
    collect(Vector{Char},partition(collect(Char, ln), 4))
end |> collect
# Determine the number of stacks by finding the number of lines until the stack number label
stack_height = findfirst(x -> length(x) == 0, partitioned_lines) - 2
num_stacks = length(partitioned_lines[stack_height+1])
# Parse the input file and create the Vector{Stack}
stacks = begin
    # Initialize an empty Vector{Stack}
    stacks = Vector{Stack}()
    # Create a Stack for each stack number
    for i in 1:num_stacks
        push!(stacks, Stack([]))
    end
    
    # Iterate through the partitioned lines and extract the block names
    for row in partitioned_lines[1:stack_height]
        for (stackidx, p)=enumerate(row)
            block_name = p[2]
            if block_name == ' '
                continue
            end
            push!(stacks[stackidx], block_name)
        end
    end
    
    foreach(reverse!, stacks)
    stacks
end

moveinstr = input_lines[stack_height+3:end]


struct Move
    times::Int
    src::Int
    dst::Int
end

# Define a regex pattern to match the input format
pattern = r"move (\d+) from (\d+) to (\d+)"

# Split the input string into lines and iterate over them
moves = map(moveinstr) do instr
    # Use the regex pattern to match the line
    m = match(pattern, instr)
    if m === nothing
        # If the line doesn't match the pattern, skip it
        throw(ArgumentError("move correctly: $instr"))
    end
    # Extract the captured groups from the regex match
    times, src, dst = m.captures
    # Convert the captured groups to integers
    times = parse(Int, times)
    src = parse(Int, src)
    dst = parse(Int, dst)
    # Create a new Move struct with the extracted fields
    Move(times, src, dst)
end |> collect

stacks

function part_one()
    for m=moves
        for t=1:m.times
            crate = pop!(stacks[m.src])
            push!(stacks[m.dst], crate)
        end
    end
end

function part_two()
    for m=moves
        # Extract the top `m.times` elements from the src stack
        crates = map(1:m.times) do i
            pop!(stacks[m.src])
        end
        # Reverse the extracted elements
        reverse!(crates)
        # Push the reversed elements to the top of the dst stack
        push!(stacks[m.dst], crates...)
    end
end

stacks
part_two()


lasts = map(last, stacks) |> String
