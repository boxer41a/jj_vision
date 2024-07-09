note
	description: "[
		Helper class for manipulating an {EV_COLOR}.  Specifically, it
		gives a range of colors starting from `color' and fading toward
		a darker or lighter color.
		Black is at the "dark" end of the scale and a dark_grey (first
		passing through a lighter color) is at the other end.
		]"
	author: "Jimmy J. Johnson"
	revision: "$Revision: 33 $"

class
	COLOR_FADER

inherit

	ANY
		redefine
			default_create
		end

create
	default_create,
	make_with_color,
	make_with_color_and_count

feature {NONE} -- Initialization

	default_create
			-- Initialize with `color' rgb = [0.5, 0.5, 0.5] (a mid-tone grey)
			-- and five steps.
		do
			create color.make_with_rgb (0.5, 0.5, 0.5)
			count := 10
		end

	make_with_color (a_color: EV_COLOR)
			-- Initialize with `a_color' and five steps
		require
			color_exists: a_color /= Void
		do
			create color.make_with_rgb (a_color.red, a_color.green, a_color.blue)
			count := 10
		end

	make_with_color_and_count (a_color: EV_COLOR; a_count: INTEGER)
			-- Set `color' and `count'
		require
			color_exists: a_color /= Void
			count_large_enough: a_count >= 0
		do
			create color.make_with_rgb (a_color.red, a_color.green, a_color.blue)
			count := a_count
		end

feature -- Access

	color: EV_COLOR
			-- The original color on which results are based

	count: INTEGER
			-- The number of steps (or max distance) to go from the original color to full dark

	distance: INTEGER
			-- The current place in the range of colors
			-- (Higher numbers are further away from `color'; a `step'
			-- of zero gives the original color.)

	i_th_darker (a_distance: INTEGER): EV_COLOR
			-- The color a `a_distance' away from `color' toward the black
		require
			distance_large_enough: a_distance >= 0
			distance_small_enough: a_distance <= count
		local
			r, g, b: REAL_32
			r_dist, g_dist, b_dist: REAL_32
			r_step, g_step, b_step: REAL_32
		do
			r_dist := Darkest - color.red
			g_dist := Darkest - color.green
			b_dist := Darkest - color.blue
			r_step := r_dist / count
			g_step := g_dist / count
			b_step := b_dist / count
			r := color.red + r_step * a_distance
			g := color.green + g_step * a_distance
			b := color.blue + b_step * a_distance
			create Result.make_with_rgb (r, g, b)
		end

	darker: EV_COLOR
			-- The color a `distance' away from `color' toward the `Darkest'
		do
			Result := i_th_darker (distance)
		end

	i_th_lighter (a_distance: INTEGER): EV_COLOR
			-- The color a `a_distance' away from `color' toward the `Grey'
		require
			distance_large_enough: a_distance >= 0
			distance_small_enough: a_distance <= count
		local
			r, g, b: REAL_32
			r_dist, g_dist, b_dist: REAL_32
			r_step, g_step, b_step: REAL_32
		do
			r_dist := Grey - color.red
			g_dist := Grey - color.green
			b_dist := Grey - color.blue
			r_step := r_dist / count
			g_step := g_dist / count
			b_step := b_dist / count
			r := color.red + r_step * a_distance
			g := color.green + g_step * a_distance
			b := color.blue + b_step * a_distance
			create Result.make_with_rgb (r, g, b)
		end

	lighter: EV_COLOR
			-- The color a `distance' away from `color' toward the lighter end
		do
			Result := i_th_lighter (distance)
		end

feature -- Element change

	set_color (a_color: EV_COLOR)
			-- Make `color' have the same rgb values as `a_color' (copies the values)
		require
			color_exists: a_color /= Void
		do
			color.set_rgb (a_color.red, a_color.green, a_color.blue)
		end

	set_count (a_count: INTEGER)
			-- Change the `count'
		require
			count_big_enough: a_count >= 0
		do
			count := a_count
		end

feature -- Basic operations

	forth
			-- Increment the `step' up to a maximum of `count'
		require
			not_after: not is_after
		do
			distance := distance + 1
		end

	back
			-- Decrement the `step' downn to a minimum of zero
		require
			not_before: not is_before
		do
			distance := distance - 1
		end

	finish
			-- Move the the last position
		do
			distance := count
		end

	start
			-- Move to the first position
		do
			distance := 1
		end

feature -- Status report

	is_before: BOOLEAN
			-- Is the `step' before the range?
		do
			Result := distance = 0
		end

	is_after: BOOLEAN
			-- Is the `step' greater than `count'
		do
			Result := distance > count
		end

feature {NONE} -- Implementation

	Lightest: REAL_32 = 0.8
			-- The lightest value to which Current will fade

	Darkest: REAL_32 = 0.2
			-- The darkest value to which Current will fade

	Grey: REAL_32 = 0.6
			-- A medium value toward which Current can fade

invariant

	color_exists: color /= Void
	count_large_enough: count >= 0

end
