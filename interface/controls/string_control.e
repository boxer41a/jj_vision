note
	description: "[
		A {CONTROL} in which to edit strings
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/controls/string_control.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	STRING_CONTROL

inherit

			-- NOTE: do not inherit from other widgets such as EV_TEXT_FIELD.  This
			-- causes too many clashes with EV_FIXED coming from CONTROL.
			-- I have gone up that path too many times.  DO NOT DO IT AGAIN!

	COMPARABLE_CONTROL
		redefine
			value
		end

create
	default_create,
	make_from_field

feature {NONE} -- Initialization

feature -- Access

	value: STRING_32
			-- A new object represented by the string in the display.
			-- Redefine to convert the displayed string into the
			-- desired type.
		do
			check attached {STRING_32} Precursor as c then
				Result := c
			end
		end

feature {NONE} -- Implementation

	default_field: STRING_FIELD
			-- Dictates appearanced of current Control
		do
			create Result
		end

end
