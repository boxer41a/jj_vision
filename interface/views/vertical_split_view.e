note
	description: "[
		A {VIEW} that is also an {EV_VERTICAL_SPLIT_AREA}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/vertical_split_view.e $"
	date:		"$Date: 2015-10-24 07:32:40 -0700 (Sat, 24 Oct 2015) $"
	revision:	"$Revision: 23 $"

class
	VERTICAL_SPLIT_VIEW

inherit

	VIEW
		undefine
--			default_create,
			copy
		redefine
			create_interface_objects,
			initialize
		end

	EV_VERTICAL_SPLIT_AREA
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
			Precursor {EV_VERTICAL_SPLIT_AREA}
		end

	initialize
			-- Set up the widget
		do
			Precursor {VIEW}
			Precursor {EV_VERTICAL_SPLIT_AREA}
			draw
		end

end
