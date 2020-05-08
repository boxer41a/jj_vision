note
	description: "[
			Used to test EDITOR classes.
			]"
	instructions: "[
			]"
	author: "Jimmy J. Johnson"
	date: "7 Mar 03"

class
	TEST_RECORD

inherit

--	JJ_SYSTEM
--		undefine
--			is_equal
--		redefine
--			default_create
--		end

	EDITABLE
		redefine
			default_create,
			Default_schema
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Create an instance for testing
		local
			s: STRING		-- data for testing
			d: YMD_TIME		-- data for testing
			i: INTEGER
		do
			Precursor {EDITABLE}
			create s.make_from_string ("this is a string for testing")
			create d.set_now
			extend_value (s, "string:")
			extend_value (d, "date:")
			extend_value (i, "number:")
			set_schema (Default_schema)
		end

feature -- Access

	Default_schema: SCHEMA
			-- Create a schema for testing
		local
			sf: STRING_FIELD
			df: YMD_TIME_FIELD
			int_f: INTEGER_FIELD
		once
			create Result
			create sf
			create df
			create int_f
			sf.set_label ("string:")
			df.set_label ("date:")
			int_f.set_label ("number:")
			sf.set_y (75)
			df.set_y (150)
			int_f.set_y (225)
			Result.extend (sf)
			Result.extend (df)
			Result.extend (int_f)
		end

end
