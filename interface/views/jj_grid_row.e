note
	description: "[
		A view (i.e. a model) representing one row in a {JJ_GRID}.
	]"
	author: "Jimmy J. Johnson"
	date: "5/24/26"

class
	JJ_GRID_ROW

inherit

	VIEW
		undefine
--			default_create,
			copy,
			is_equal
		redefine
			create_interface_objects,
			initialize
		end

	EV_GRID_ROW
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end

create
	default_create,
	make

--create {JJ_MODEL_WORLD_VIEW}
--	list_make

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation
            -- bridge pattern.
		do
			Precursor {EV_GRID_ROW}
			Precursor {VIEW}
		end

	initialize
			-- Set up the tool
		do
			Precursor {EV_GRID_ROW}
			Precursor {VIEW}
		end

feature -- Element change

feature -- Basic operations

feature {NONE} -- Implementation


end
