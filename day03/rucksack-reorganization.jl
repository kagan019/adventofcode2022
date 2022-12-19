inpt = cd("day03") do
    map(readlines("input.txt")) do ln
        collect(Char,ln)
    end
end

charinboth = map(inpt) do s
    n = div(length(s), 2)
    left = s[1:n]
    right = s[n+1:end]
    right_set = Set(right)
    for c in left
        if c in right_set
            return c
        end
    end
    throw(ArgumentError("check string $left and $right"))
end

groups = Iterators.partition(inpt,3)
charsinallthree = map(groups) do grp
    @assert length(grp) == 3
    mid_set = Set(grp[2])
    right_set = Set(grp[3])
    for c in grp[1]
        if c in mid_set && c in right_set
            return c
        end
    end
end

function priority(c::Char)
    if c >= 'a'
        return c - 'a' + 1
    else
        return c - 'A' + 27
    end
end

priority('L')
sum(priority.(charinboth))
# part 2
sum(priority.(charsinallthree))