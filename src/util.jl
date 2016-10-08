
"Make a window from the context vector, with half (round down) of the window on each side of the index"
function window_excluding_center(index::Integer, context::AbstractVector, window_size::Integer)
    window_lower_bound = max(index - window_size÷2, 1)
    window_upper_bound = min(index + window_size÷2, length(context))
	view(context, [window_lower_bound:index-1;index+1:window_upper_bound])
end

