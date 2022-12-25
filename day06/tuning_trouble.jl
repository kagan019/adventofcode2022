using Base.Iterators

# Read the string from the file
inpt = cd("day06") do 
    read("input.txt", String)
end

# Find the index of the first occurrence of 4 characters that are all distinct
x = map(1:length(inpt) - 3) do i
    if length(Set(inpt[i:i+3])) == 4
        [i]
    else
        []
    end
end |> flatten |> collect

x[1] + 3

x = map(1:length(inpt) - 13) do i
    if length(Set(inpt[i:i+13])) == 14
        [i]
    else
        []
    end
end |> flatten |> collect

x[1] + 13