note
	description: "[
		An {EV_MODEL_WORLD} that is also a {VIEW}.
		It is a group of figures that allow redraws through the {VIEW}
		class interface (e.g. when the underlying object model changes,
		the views displaying that object can be redrawn.)
	]"
	author: "Jimmy J. Johnson"
	date: "$Date$"
	revision: "$Revision$"

class
	JJ_MODEL_WORLD_VIEW

inherit

	VIEW
		redefine
			default_create,
			create_interface_objects,
			draw
		end

	EV_MODEL_WORLD
		redefine
			default_create,
			create_interface_objects
		end

create
	default_create

create {JJ_MODEL_WORLD_VIEW}
	list_make

feature {NONE} -- Initialization

	frozen default_create
			-- Create an instance.
			-- Creation feature added to align more with the usage pattern of
			-- descendents of EV_ANY, since EV_MODEL_WORLD is a descendent of
			-- ANY--not EV_ANY.
			-- The feature calls `create_interface_objects' via `default_create'
			-- defined in EV_MODEL.  It then calls `initialize'.
		do
--			Precursor {VIEW}				-- {VIEW} undefines `default_create'
			Precursor {EV_MODEL_WORLD}  -- calls `create_interface_objects'
			initialize	-- from {VIEW}
--			add_actions	-- from {VIEW}
		end

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {VIEW}
			Precursor {EV_MODEL_WORLD}
		end

feature -- Access

	parent: detachable EV_CONTAINER
			-- Parent of the current view.
			-- To be effected by joining with an EV_ class.
			-- An {EV_MODEL_WORLD} as a descendent of {EV_MODEL} is to be
			-- extended into an {EV_MODEL_WORLD_CELL}, which is an {EV_CONTAINER},
			-- but there seems to be no way to determine this container.
		do
			check
				do_not_call: False then
					-- because can not return what is expected.
			end
		end

	is_destroyed: BOOLEAN
			-- Has the view been destroyed?
			-- This will be joined with an EV_WIDGET feature.
			-- See comment for feature `parent'.
		do
--			check
--				do_not_call: False then
--					-- because can not return what is expected.
--			end
			Result := false
		end

feature -- Basic operations

	draw
			-- Redraw the window
		do
--			world.wipe_out
--			world.full_redraw
			Precursor {VIEW}
		end

end
