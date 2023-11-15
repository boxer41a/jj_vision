note
	description: "[
				A {CONTROL} which allows the editting of a {COMPARABLE}.
				]"
	date: "24 Feb 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/controls/comparable_control.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

deferred class
	COMPARABLE_CONTROL

inherit

	CONTROL
		redefine
			value,
			default_field
		end

feature -- Access

	value: COMPARABLE
			-- A new object represented by the display.
			-- Define to convert the display into the
			-- desired type.
		do
			check attached {COMPARABLE} Precursor as c then
				Result := c
			end
		end

feature {FIELD_EDITOR_VIEW} -- Implementation

	default_field: COMPARABLE_FIELD
			-- Create a field to be used if Current was `default_create'd.
			-- The anchor for `field'.
		deferred
		end

end
