note
	description	: "[
		A scrollable drawing area (i.e. an {EV_MODEL_WORLD_CELL} that 
		is a {VIEW} displaying zero or more {JJ_MODEL_WORLD_GRID_ROW}
		]"
	author:		"Jimmy J. Johnson"
	date:  "5/23/26"

class
	JJ_GRID_VIEW

inherit

	VIEW
		undefine
--			default_create,
			copy,
			is_equal
		redefine
			create_interface_objects,
			initialize
--			draw
		end

	EV_GRID
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize,
			row_type
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
			Precursor {EV_GRID}
			Precursor {VIEW}
		end

	initialize
			-- Set up by calling both precursor versions
		do
			Precursor {EV_GRID}
			Precursor {VIEW}
		end

feature -- Element change

	set_header_labels (a_list: ARRAYED_LIST [STRING])
			-- Build the headerrow based on items in `a_list'
			-- The items in `a_list' become the column labels and the
		local
			i: INTEGER
			s: STRING
			r: JJ_GRID_ROW
			t: EV_GRID_HEADER_ITEM

			a: ANY
		do
--			from i := 1
--			until i > a_list.count
--			loop
--				create r
--				s := a_list.i_th (i)
--				create t
----				t.set_text (s)
--				header.extend (t)
--				i := i + 1
--			end
		end

feature -- Basic operations

	add_row (a_row: JJ_GRID_ROW)
			-- Add a row to Current
		do

		end

feature {NONE} -- Implementation

	row_type: JJ_GRID_ROW	--  EV_GRID_ROW
			-- Type used for row objects.
			-- May be redefined by EV_GRID descendents.
		require else
			callable: False
		do
			check
				do_not_call: False then
			end
		end

end
