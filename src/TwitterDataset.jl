struct Twitter{}

end

function Twitter()
end

Twitter() = Twitter(datadep"Twitter dataset")

MultiResolutionIterators.levelname_map() = [
:paragraph => 1,
:sentence => 2,
:words => 3, :tokens => 3,
:charater => 4
]
