note
	description: "[
		A {FIELD} describing the placement of a {STRING_CONTROL}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/fields/string_field.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class STRING_FIELD
	-- creates an edit box.

inherit

	COMPARABLE_FIELD
		redefine
			type
		end

create
	default_create

feature {NONE} -- Initialization

feature -- Access

feature -- Querry

	type: STRING_32
			-- Implementation (and anchor) of `value'.
			-- Redefined to change type.
		once
			create Result.make_from_string ("")
		end

	as_type (a_string: STRING_32): like type
			-- Convert `a_string' to an object of `Type'.
		do
			Result := a_string
		end

feature -- Transformation

	as_widget: STRING_CONTROL
		do
			create Result.make_from_field (Current)
		end

end
