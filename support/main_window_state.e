note
	description: "[
		Used by {JJ_MAIN_WINDOW} to persist "state" attributes (size,
		position, height, width, etc.) of the {JJ_MAIN_WINDOW}
		]"
	date: "10 Sep 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/main_window_state.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	MAIN_WINDOW_STATE

inherit

	VIEW_STATE
		redefine
			default_create,
			make,
			set_view_attributes,
			new_view
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	default_create
			-- Initialize with reasonable values
		do
			x := Default_x
			y := Default_y
			height := Default_height
			width := Default_width
-- FIX ME!
--			create split_manager_state
		end

	make (a_window: JJ_MAIN_WINDOW)
			-- Initialize from attributes of `a_window'.
		do
			Precursor {VIEW_STATE} (a_window)
			x := a_window.x_position
			y := a_window.y_position
			width := a_window.width
			height := a_window.height
			is_minimized := a_window.is_minimized
			is_maximized := a_window.is_maximized
		end

feature -- Access

	set_view_attributes
			-- set up the view
		do
			view.set_position (x, y)
			view.set_size (width, height)
			if is_maximized then
				view.maximize
			elseif is_minimized then
				view.minimize
			else
				view.restore
			end
		end

	x: INTEGER_32
			-- Stores the `x_position' of a window

	y: INTEGER_32
			-- Stores the `y_position' of a window

	height: INTEGER_32
			-- Stores the `height' of a window

	width: INTEGER_32
			-- Stores the `width' of a window

	is_minimized: BOOLEAN
			-- Stores the `is_minimized' state of the window

	is_maximized: BOOLEAN
			-- Stores the `is_maximized' state of the window

feature -- Element change

	set_x (a_value: INTEGER_32)
			-- Change `x'
		require
			value_big_enough: a_value >= 0
		do
			x := a_value
		end

	set_y (a_value: INTEGER_32)
			-- Change `y'
		require
			value_big_enough: a_value >= 0
		do
			y := a_value
		end

	set_height (a_value: INTEGER_32)
			-- Change `height'
		require
			value_big_enough: a_value >= 0
		do
			height := a_value
		end

	set_width (a_value: INTEGER_32)
			-- Change `width'
		require
			value_big_enough: a_value >= 0
		do
			width := a_value
		end

	set_minimized
			-- Make `is_minimized' True
		do
			is_minimized := True
		end

	set_maximized
			-- Make `is_maximized' True
		do
			is_maximized := True
		end

feature {NONE} -- Implementation (constants)

	Default_x: INTEGER = 100
			-- Default value for `x'

	Default_y: INTEGER = 100
			-- Default value for `y'

	Default_height: INTEGER = 300
			-- Default value for `height'

	Default_width: INTEGER = 600
			-- Default value for `width'

feature {NONE} -- Implementation

	new_view: JJ_MAIN_WINDOW
			-- Create the `view_imp'
		do
			create Result
		end

invariant

--	split_manager_state_exists: split_manager_state /= Void

end
