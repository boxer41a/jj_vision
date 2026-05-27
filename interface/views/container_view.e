note
	description: "[
		An {EV_CONTAINER} that is also a {VIEW} for holding one widget.
		]"
	author:		"Jimmy J. Johnson"
	date: "5/23/26"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"

class
	CONTAINER_VIEW

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

	EV_CELL
		rename
			object_id as ise_object_id
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
			Precursor {VIEW}
			Precursor {EV_CELL}
		end

	initialize
			-- Create an editor view.
		do
			Precursor {EV_CELL}
			Precursor {VIEW}
		end

end

