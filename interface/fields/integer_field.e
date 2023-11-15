note
	description: "[
		A {FIELD} used to create a {INTEGER_CONTROL} and position that control.
		]"
	date: "24 Feb 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/fields/integer_field.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	INTEGER_FIELD

inherit

	COMPARABLE_FIELD
		redefine
			default_create,
			is_valid_data,
			string_to_type
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Create an instance
		do
			Precursor {COMPARABLE_FIELD}
		end

feature -- Querry

	Type: INTEGER_REF
			-- Implementation (and anchor) of `value'.
			-- Redefined to change type.
		once
			create Result
		end

	string_to_type (a_string: STRING_32): like type
			-- Convert `a_string' to an object of `Type'.
		do
			create Result
			Result.set_item (a_string.to_integer)
		end

	is_valid_data (a_value: ANY): BOOLEAN
			-- Is the value in the display a valid representation
			-- for the type of the data.
		do
			Result := Precursor {COMPARABLE_FIELD} (a_value)
			if not Result then
					-- It may be that `a_value' is a STRING representation
					-- of an integer, so check the string and convert it.
				if attached {STRING} a_value as s then
					Result := s.is_integer
				end
			end
		end

feature -- Transformation

	as_widget: INTEGER_CONTROL
			-- Create the appropriate type of control
		do
			create Result.make_from_field (Current)
		end

end
