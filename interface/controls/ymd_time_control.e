note
	description: "[
			Used with {EDITOR} classes to make EV_WIDGETs for displaying and
			editting data which is a {YMD_TIME}
			]"
	date: "7 Mar 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/controls/ymd_time_control.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"


class
	YMD_TIME_CONTROL

inherit

	YMD_CONSTANTS
		undefine
			default_create,
			is_equal,
			copy
		end

	SPIN_CONTROL
		redefine
			create_interface_objects,
			initialize,
			value,
			increment,
			decrement
		end

create
	default_create,
	make_from_field

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {SPIN_CONTROL}
			set_delta (One_day)
		end

	initialize
			-- Set up the control
		do
			Precursor {SPIN_CONTROL}
		end


feature -- Access

	value: YMD_TIME
			-- A new object represented by the string in the display.
			-- Redefine to convert the displayed string into the
			-- desired type.
		do
			check attached {YMD_TIME} Precursor {SPIN_CONTROL} as c then
				Result := c
			end
		end

	delta: YMD_DURATION
			-- The amount to change `value' when one of the buttons is pressed.

feature -- Element change

	set_delta (a_delta: like delta)
			-- Change `delta'
		require
			positive_delta: not a_delta.is_negative
		do
			delta := a_delta.twin
		ensure
			delta_assigned: equal (delta, a_delta)
		end

feature -- Basic operations

	increment
			-- Increase the `value' by amount `step'.
		do
			Precursor {SPIN_CONTROL}
			set_data (value + delta)
			on_display_changed
		end

	decrement
			-- Decrease the `value' by amount `step'.
		do
			Precursor {SPIN_CONTROL}
			set_data (value - delta)
			on_display_changed
		end

feature {NONE} -- Implementation

	default_field: YMD_TIME_FIELD
			-- Dictates appearanced of current Control
		do
			create Result
		end

end
