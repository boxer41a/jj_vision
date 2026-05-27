note
	description	: "[
		A scrollable drawing area (i.e. an {EV_MODEL_WORLD_CELL} that 
		is a scrollable {VIEW}.
		]"
	author:		"Jimmy J. Johnson"

class
	JJ_MODEL_WORLD_CELL_VIEW

inherit

	VIEW
		undefine
--			default_create,
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
	default_create,
	make

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
				-- Must create `world' because not calling `make_with_world'
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

feature -- Basic operations

	add_model (a_model: JJ_MODEL_WORLD_VIEW)
			-- Add `a_model' to the `world' and set
			-- the `parent' of `a_model'
		do
			world.extend (a_model)
			a_model.set_parent_view (Current)
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
