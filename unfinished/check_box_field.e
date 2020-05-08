note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision: "$Revision: 7 $"

class

	CHECK_BOX_FIELD

inherit

	FIELD
		redefine
			Type,
			is_valid
		end

create
	default_create

feature -- Access

	Type: BOOLEAN_REF
			-- Implementation (and anchor) of `value'.
			-- Redefined to change type.
		once
			create Result
		end

	as_type (a_string: STRING): BOOLEAN
			-- Convert `a_string' to an object of `Type'.
		do
			Result := a_string.same_string (("True").to_upper)
		end

feature -- Transformation

	as_widget: CHECK_BOX_CONTROL
			-- Create a control from this field
		do
			create Result.make_from_field (Current)
		end

end -- class CHECK_BOX_FIELD
