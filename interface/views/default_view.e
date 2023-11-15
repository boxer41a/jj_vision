note
	description: "[
		Used by {VIEW_MANAGER} as a place holder when it has
		no other views.
		]"
	date: "29 Aug 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/default_view.e $"
	date:		"$Date: 2015-10-24 07:32:40 -0700 (Sat, 24 Oct 2015) $"
	revision:	"$Revision: 23 $"

class
	DEFAULT_VIEW

inherit

	VIEW
		undefine
			copy
		redefine
			create_interface_objects,
			initialize
		end

	EV_LABEL
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
			Precursor {EV_LABEL}
		end

	initialize
			-- Set up the view
		do
			Precursor {VIEW}
			Precursor {EV_LABEL}
			set_text ("Default view")
		end

end
