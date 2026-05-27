note
	description: "[
		A {VIEW} that displays `row' of data elements arranged in columns.
		A `header_row' controls the size of the columns and remains visible
		when scroling.
	]"
	author: "Jimmy J. Johnson"
	date: "5/24/26"

class
	JJ_GRID

inherit

	VIEW
		undefine
			copy,
			is_equal
		redefine
			create_interface_objects,
			initialize,
			draw
		end

	EV_VERTICAL_BOX
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end

create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'.
			-- Called by `defult_create'.
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation
			-- bridge pattern.
		do
			Precursor {VIEW}
			Precursor {EV_VERTICAL_BOX}
			create rows.make (0)
		end

	initialize
			-- Set up the tool
		do
			Precursor {EV_VERTICAL_BOX}
			Precursor {VIEW}
		end

feature -- Status report

	has_header: BOOLEAN
			-- Does Current have a header to display?
		do
			Result := attached header_imp
		end

feature -- Basic operations

	add_header (a_row: like header)
			-- Make `a_row' the `header' row in Current
		require
			is_parented: a_row.parent = Void
		do
			header_imp := a_row
		end

	draw
			-- Build the view
		do

		end

feature {NONE} -- Implementation

	header: like header_anchor
			-- The row at top of view containing column labels
		require
			has_header: has_header
		do
			check attached header_imp as h then
				Result := h
			end
		end

	header_imp: detachable like header_anchor
			-- Row at top of window listing names (other other stuff) about a column
			-- Implementation for `header'

	rows: ARRAYED_LIST [like row_anchor]
			-- The rows of data displayed by Current

	header_anchor: JJ_GRID_ROW
			-- Type anchor for features accessing the `header'.			
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because this feature gives no info; simply used as anchor.
			end
		end

	row_anchor: JJ_GRID_ROW
			-- Type anchor for features accessing a `row'.			
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because this feature gives no info; simply used as anchor.
			end
		end

end
