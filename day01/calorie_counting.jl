inpt = cd("day01") do 
    read("input.txt", String)
end

struct Elf
    inv :: Vector{Int32}
end
function sum_elf(e :: Elf)
    sum(e.inv)
end

elves = map(split(inpt, "\n\n")) do elf
    Elf(map(split(elf, "\n")) do cal
        parse(Int32, cal)
    end)
end

elves

best_elf = maximum(sum_elf, elves)


sort!(elves, by=sum_elf)
reverse!(elves)
Iterators.take(elves,3) |> Base.Fix1(map, sum_elf) |> sum