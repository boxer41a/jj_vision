note
	description: "[
		A {VIEW} combined with an EV_DRAWING_AREA
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/jj_drawing_area_view.e $"
	date:		"$Date: 2012-11-27 20:19:38 -0500 (Tue, 27 Nov 2012) $"
	revision:	"$Revision: 13 $"

class
	JJ_DRAWING_AREA_VIEW

inherit

	EV_DRAWING_AREA
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end

	VIEW
		undefine
			copy
		redefine
			create_interface_objects,
			initialize,
			add_actions
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
			Precursor {EV_DRAWING_AREA}
		end

	initialize
			-- Set up the widget
		do
			Precursor {VIEW}
			Precursor {EV_DRAWING_AREA}
--			set_actions
		end

	add_actions
		do
			resize_actions.force_extend (agent draw)
			expose_actions.force_extend (agent draw)
		end

end
