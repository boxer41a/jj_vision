note
	description: "[
		A reference to a {FIELD} for use by once feature
		`user_identifier_field' from {SCHEMA}
		]"
	date: "7 Oct 07"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/fields/field_ref.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"
	
class
	FIELD_REF

create
	set_field

feature -- Access

	field: FIELD
		-- Item held by current

feature -- Element change

	set_field (a_field: FIELD)
			-- Change the `field'.
		do
			field := a_field
		end

end
