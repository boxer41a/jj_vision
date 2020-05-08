note
	description: "[
		A {FIELD} decribing the placement of a {YMD_TIME_CONTROL}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/fields/ymd_time_field.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	YMD_TIME_FIELD

inherit

	COMPARABLE_FIELD
		redefine
			Type,
			is_valid_data,
			string_to_type,
			type_to_string
		end

create
	default_create

feature -- Access

	Type: YMD_TIME
			-- Implementation (and anchor) of `value'.
			-- Redefined to change type.
		once
			create Result.set_now
		end

	is_valid_data (a_value: ANY): BOOLEAN
			-- Is the value in `a_value' a valid representation
			-- for the `Type' of the data.
		local
			f: YMD_TIME_FORMATTER
		do
			Result := Precursor {COMPARABLE_FIELD} (a_value)
			if not Result then
					-- It may be that `a_value' is a STRING representation
					-- of a date, so check the string and convert it.
				create f
				if attached {STRING} a_value as s then
					Result := f.is_valid (s)
				end
			end
		end

	string_to_type (a_string: STRING_32): like Type
			-- Convert `a_string' to a YMD_TIME
		local
			f: YMD_TIME_FORMATTER
		do
			create f
			Result := f.to_ymd_time (a_string)
		end

	type_to_string (a_value: ANY): STRING_32
			-- The string representation of `a_value'.
		local
			f: YMD_TIME_FORMATTER
		do
			if attached {YMD_TIME} a_value as t then
				create f
				Result := f.to_string (t)
			else
				Result := Precursor {COMPARABLE_FIELD} (a_value)
			end
		end

feature -- Transformation

	as_widget: YMD_TIME_CONTROL
		do
			create Result.make_from_field (Current)
		end

end
