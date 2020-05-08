note
	description: "[
		An EV_FIXED which is also a {VIEW}
		]"
	date: "12 Sep 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/fixed_view.e $"
	date:		"$Date: 2015-10-24 07:32:40 -0700 (Sat, 24 Oct 2015) $"
	revision:	"$Revision: 23 $"

class
	FIXED_VIEW

inherit

	VIEW
		undefine
			copy,
			is_equal
		redefine
			create_interface_objects,
			initialize
		end

	EV_FIXED
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
			Precursor {EV_FIXED}
		end

	initialize
			-- Create an editor view.
		do
			Precursor {EV_FIXED}
			Precursor {VIEW}
		end

end
