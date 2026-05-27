note
	description	: "[
		An item that is also a {VIEW} for holding a {REGISTER} and for
		insertion into a JJ_GRID.
		]"
	author:		"Jimmy J. Johnson"
	date:  "5/25/26"

class
	JJ_GRID_ITEM

inherit

	VIEW
		rename
			target as register
		undefine
			copy,
			is_equal
		redefine
			create_interface_objects,
			initialize
		end

	EV_GRID_ITEM
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation
            -- bridge pattern.
		do
			Precursor {EV_GRID_ITEM}
			Precursor {VIEW}
		end

	initialize
			-- Set up by calling both precursor versions
		do
			Precursor {EV_GRID_ITEM}
			Precursor {VIEW}
		end

end
