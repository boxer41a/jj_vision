note
	description: "[
		A {CONTROL} for changing integers
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/controls/integer_control.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	INTEGER_CONTROL

inherit

	SPIN_CONTROL
		redefine
			initialize,
			value,
			set_actions,
			increment,
			decrement
		end

create
	default_create,
	make_from_field

feature {NONE} -- Initialization

	initialize
			-- Set up the object
		do
			Precursor {SPIN_CONTROL}
			delta := 1
		end

	set_actions
			-- Add actions to the `display'.
		do
			Precursor {SPIN_CONTROL}
		end

feature -- Access

	value: INTEGER_REF
			-- A new object represented by the string in the display.
			-- Redefine to convert the displayed string into the
			-- desired type.
		do
			check attached {INTEGER_REF} Precursor {SPIN_CONTROL} as c then
				Result := c
			end
		end

	delta: INTEGER
			-- The amount to change `value' when one of the buttons is pressed.

feature -- Element change

	set_delta (a_delta: INTEGER)
			-- Change `delta'
		require
			positive_delta: a_delta > 0
		do
			delta := a_delta
		ensure
			delta_assigned: delta = a_delta
		end

feature -- Basic operations

	increment
			-- Increase the `value' by amount `step'.
		do
			Precursor {SPIN_CONTROL}
			set_data (value.item + delta)
			on_display_changed
		end

	decrement
			-- Decrease the `value' by amount `step'.
		do
			Precursor {SPIN_CONTROL}
			set_data (value.item - delta)
			on_display_changed
		end

feature {NONE} -- Implementation

	default_field: INTEGER_FIELD
			-- Dictates appearanced of current Control
		do
			create Result
		end

invariant

	positive_delta: delta > 0

end
