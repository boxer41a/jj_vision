note
	description: "[
		A {FIELD} used to create a control to edit a COMPARABLE.
		]"
	date: "24 Feb 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/fields/comparable_field.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"


deferred class
	COMPARABLE_FIELD

inherit

	FIELD
		redefine
			default_create,
			as_widget,
			Type
		end

feature {NONE} -- Initialization

	default_create
			-- Initialize `Current'.
		do
			Precursor {FIELD}
		end

feature -- Transformation

	as_widget: COMPARABLE_CONTROL
			-- Each descendent class must create the appropriate control.
			-- Redefined to change the type.
		deferred
		end

feature --

	Type: COMPARABLE
			-- Anchor for `value'
		deferred
		end

end
