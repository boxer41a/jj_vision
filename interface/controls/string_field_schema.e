note
	description: "[
		A {SCHEMA} that describes placement of a {INTEGER_FIELD}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/controls/string_field_schema.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	STRING_FIELD_SCHEMA

inherit

	FIELD_SCHEMA
		redefine
			default_create
		end

create
	default_create
create {LINKED_LIST}
	make

feature {NONE} -- Initialize

	default_create
			-- Create an instance
		do
			Precursor {FIELD_SCHEMA}
			extend (length_field)
		end

feature -- Access

	length_field: INTEGER_FIELD
			-- Create a field to store the `number_of_characters' of a FIELD
		once
			create Result
			Result.set_label ("Length")
			Result.set_x (30)
			Result.set_y (0)
			Result.set_width (50)
		end

end
