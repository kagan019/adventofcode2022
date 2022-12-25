struct FSID
    id::Int
end

struct File
    id::FSID
    name::String
    size::Int
    parent::FSID
end

struct Dir
    id::FSID
    name::String
    contents::Dict{FSID, Union{File, Dir}}
    parent::FSID
end

function parse_input(input::String)
    lines = split(input, "\n")
    current_dir = FSID(0)
    dirs = Dict{FSID, Dir}()
    dirs[current_dir] = Dir(current_dir, "/", Dict{FSID, Union{File, Dir}}(), FSID(0))
    next_fsid = 1

    for line in lines
        if line[1] == '$'
            # Parse command
            fullcmd = split(line[2:end])
            (cmd, args) = (fullcmd[1], fullcmd[2:end])
            if cmd == "cd"
                if args[1] == "/"
                    current_dir = FSID(0)
                elseif args[1] == ".."
                    current_dir = dirs[current_dir].parent
                else
                    for (_, dir) in dirs[current_dir].contents
                        if isa(dir, Dir) && dir.name == args[1]
                            current_dir = dir.id
                            break
                        end
                    end
                end
            end
        else
            # Parse output
            fields = split(line)
            if fields[1] == "dir"
                # Add new directory
                dir_id = FSID(next_fsid)
                next_fsid += 1
                dir = Dir(dir_id, fields[2], Dict{FSID, Union{File, Dir}}(), current_dir)
                dirs[dir_id] = dir
                dirs[current_dir].contents[dir_id] = dir
            else
                # Add new file
                file = File(FSID(next_fsid), fields[2], parse(Int, fields[1]), current_dir)
                next_fsid += 1
                dirs[current_dir].contents[file.id] = file
            end
        end
    end
    return dirs
end

import Base: +

function size(f :: File)
    f.size
end
function size(dir::Dir)
    sz = 0
    for content in values(dir.contents)
        sz += size(content)
    end
    sz
end

function find_small_dirs(dir::Dir, max_size::Int)
    small_dirs = []
    if size(dir) <= max_size
        push!(small_dirs, dir)
    end
    for content in values(dir.contents)
        if content isa Dir
            small_dirs = [small_dirs ; find_small_dirs(content, max_size)]
        end
    end
    small_dirs
end

input = cd("day07") do
    read("input.txt", String)
end

# table of all directories
dirs = parse_input(input)

# find all directories with a total size of at most 100000
small_dirs = find_small_dirs(dirs[FSID(0)], 100000)

# calculate the sum of the total sizes of these directories
total_size = sum(size, small_dirs)

fs_size = 70_000_000
desired_space = 30_000_000
used_space = size(dirs[FSID(0)])

# part 2
function find_smallest_dir(dir::Dir, min_size::Int)
    smallest_dir = nothing
    if fs_size - used_space + size(dir) >= desired_space
        smallest_dir = dir
    end
    for content in values(dir.contents)
        if content isa Dir
            candidate_dir = find_smallest_dir(content, min_size)
            if candidate_dir !== nothing
                if smallest_dir === nothing || size(candidate_dir) < size(smallest_dir)
                    smallest_dir = candidate_dir
                end
            end
        end
    end
    smallest_dir
end

# find the smallest directory at least as large as 30000000
smallest_dir = find_smallest_dir(dirs[FSID(0)], 30000000)
size(smallest_dir)