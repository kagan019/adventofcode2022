

struct Round
    you :: Symbol
    opp :: Symbol
end

shape_score = Dict([
    :rock => 1,
    :paper => 2,
    :scissors => 3,
])

function battle(r :: Round)
    y = shape_score[r.you] - 1
    o = shape_score[r.opp] - 1
    outcome = (3 + y - o) % 3
    return [:tie, :win, :loss][outcome+1]
end

function score(r :: Round)
    
    battle_score = Dict([
        :win => 6,
        :tie => 3,
        :loss => 0
    ])
    shape_score[r.you] + battle_score[battle(r)]
end

function play_shape(opp_move :: Symbol, goal :: Symbol) :: Symbol
    if goal == :win
        if opp_move == :rock
            return :paper
        elseif opp_move == :scissors
            return :rock
        else
            return :scissors
        end
    elseif goal == :tie
        return opp_move
    else
        if opp_move == :rock
            return :scissors
        elseif opp_move == :scissors
            return :paper
        else
            return :rock
        end
    end
end

opp_move = Dict([
    'A' => :rock,
    'B' => :paper,
    'C' => :scissors
])
your_move = Dict([
    'X' => :rock,
    'Y' => :paper,
    'Z' => :scissors
])
your_direction = Dict([
    'X' => :lose,
    'Y' => :tie,
    'Z' => :win
])


part = :part_two

inpt = cd("day02") do
    map(readlines("input.txt")) do ln
        ln2 = collect(Char,ln)
        @assert length(ln2) >= 3
        if part == :part_one
            Round(your_move[ln2[3]], opp_move[ln2[1]])
        else
            om = opp_move[ln2[1]]
            gl = your_direction[ln2[3]]
            Round(play_shape(om,gl), om)
        end
    end
end

sum(score.(inpt))