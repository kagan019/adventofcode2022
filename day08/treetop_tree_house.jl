# Define a struct to represent a single tree in the grid
struct Tree
    height::Int8
    row::Int8
    col::Int8
end

# Define a function to parse the input string into a 2D array of Tree objects
function parse_input(input_string::String)
    # Split the input string into lines
    lines = split(input_string, "\n")

    # Create an empty 2D array to store the Tree objects
    trees = Array{Tree}(undef, length(lines), length(lines[1]))

    # Iterate over the lines and characters, creating a Tree object for each one
    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            trees[i, j] = Tree(parse(Int8, c), i, j)
        end
    end

    return trees
end

# Define a function to count the number of visible trees
function count_visible_trees(trees::Array{Tree, 2})
    visible_count = 0

    # Iterate over the trees
    for tree in trees
        # Check if the tree is visible from the left
        left_visible = true
        for i in tree.col-1:-1:1
            if trees[tree.row, i].height >= tree.height
                left_visible = false
                break
            end
        end

        # Check if the tree is visible from the right
        right_visible = true
        for i in tree.col+1:size(trees, 2)
            if trees[tree.row, i].height >= tree.height
                right_visible = false
                break
            end
        end

        # Check if the tree is visible from the top
        top_visible = true
        for i in tree.row-1:-1:1
            if trees[i, tree.col].height >= tree.height
                top_visible = false
                break
            end
        end

        # Check if the tree is visible from the bottom
        bottom_visible = true
        for i in tree.row+1:size(trees, 1)
            if trees[i, tree.col].height >= tree.height
                bottom_visible = false
                break
            end
        end

        # If the tree is visible from any direction, increment the visible count
        if left_visible || right_visible || top_visible || bottom_visible
            visible_count += 1
        end
    end

    return visible_count
end

# Read the input from "input.txt"
input_string = cd("day08") do 
    read("input.txt", String)
end

# Parse the input string into a 2D array of Tree objects
trees = parse_input(input_string)

# Count the number of visible trees
visible_count = count_visible_trees(trees)

# part 2

function compute_tree_score(trees::Array{Tree, 2}, row::Int, col::Int)
    # Initialize the viewing distances and scenic score to 1
    up_distance = 0
    down_distance = 0
    left_distance = 0
    right_distance = 0
    scenic_score = 1

    # Compute the viewing distance in the up direction
    for i in row-1:-1:1
        up_distance += 1
        if trees[i, col].height >= trees[row, col].height
            break
        end
    end

    # Compute the viewing distance in the down direction
    for i in row+1:size(trees, 1)
        down_distance += 1
        if trees[i, col].height >= trees[row, col].height
            break
        end
    end

    # Compute the viewing distance in the left direction
    for i in col-1:-1:1
        left_distance += 1
        if trees[row, i].height >= trees[row, col].height
            break
        end
        
    end

    # Compute the viewing distance in the right direction
    for i in col+1:size(trees, 2)
        right_distance += 1
        if trees[row, i].height >= trees[row, col].height
            break
        end
    end

    # Compute the scenic score
    scenic_score = up_distance * down_distance * left_distance * right_distance
    return scenic_score
end
        

function compute_largest_scenic_score(trees::Array{Tree, 2})
    # Initialize the maximum scenic score to 0
    max_scenic_score = 0

    # Iterate over the trees in the matrix
    for i in 1:size(trees, 1)
        for j in 1:size(trees, 2)
            # Compute the viewing distances and scenic score of the current tree
            scenic_score = compute_tree_score(trees, i, j)
            # Update the maximum scenic score if necessary
            if scenic_score > max_scenic_score
                max_scenic_score = scenic_score
            end
        end
    end

    return max_scenic_score
end

# compute_tree_score(trees, 2,3)
compute_largest_scenic_score(trees)