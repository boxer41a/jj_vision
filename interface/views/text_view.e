note
	description: "[
		A {VIEW} in which to display text
		]"
	date: "4 Jan 08"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/text_view.e $"
	date:		"$Date: 2012-05-31 14:05:35 -0400 (Thu, 31 May 2012) $"
	revision:	"$Revision: 10 $"

class
	TEXT_VIEW

inherit

	EV_TEXT
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
			Precursor {EV_TEXT}
		end

	initialize
			-- Set up the widget
		do
			Precursor {VIEW}
			Precursor {EV_TEXT}
			set_actions
			draw
		end

	set_actions
		do
			resize_actions.force_extend (agent draw)
		end

end
