note
	description: "[
		A {FIELD} in which to edit formulas
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/fields/formula_field.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class FORMULA_FIELD
	-- creates an edit box.

inherit

	STRING_FIELD
		redefine
			is_valid_data
		end

create
	default_create

feature -- Access

	is_valid_data (a_data: ANY): BOOLEAN
			-- Is the value in `a_data' a valid representation
			-- for the `Type' of the data.
		local
--			scan: SCANNER
--			s: STRING
		do
----			create scan
--			s ?= a_data
--			if s /= Void then
----				scan.scan_string (s)
--			end
----			Result := Precursor {STRING_FIELD} (a_data) and then not scan.scanning_error
		end

end
