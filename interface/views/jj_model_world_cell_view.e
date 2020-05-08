note
	description	: "[
		A scrollable drawing area (i.e. an {EV_MODEL_WORLD_CELL} that 
		is a {VIEW}.
		]"
	author:		"Jimmy J. Johnson"

class
	JJ_MODEL_WORLD_CELL_VIEW

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

	EV_MODEL_WORLD_CELL
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			create world
			Precursor {EV_MODEL_WORLD_CELL}
			Precursor {VIEW}
			is_autoscroll_enabled := true
		end

	initialize
			-- Set up by calling both precursor versions
		do
			Precursor {EV_MODEL_WORLD_CELL}
			Precursor {VIEW}
		end

feature {NONE} -- Drawing / Refresh operations

	draw
			-- Build the view
		do
			drawing_area.clear
			if projector /= Void then
				projector.full_project
			end
		end

end
