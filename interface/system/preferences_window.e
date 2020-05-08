note
	description: "[
		A {VIEW} dialog for setting user preverences
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/system/preferences_window.e $"
	date:		"$Date: 2015-10-24 07:32:40 -0700 (Sat, 24 Oct 2015) $"
	revision:	"$Revision: 23 $"


class
	PREFERENCES_WINDOW

inherit

	SPLIT_VIEW
		undefine
--			default_create,
			copy
		redefine
			create_interface_objects,
			initialize
		end

	EV_TITLED_WINDOW
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
			Precursor {SPLIT_VIEW}
			Precursor {EV_TITLED_WINDOW}
		end

	initialize
			-- Set up the window
		do
			Precursor {EV_TITLED_WINDOW}
			Precursor {SPLIT_VIEW}
			set_title ("System Preferences")
			split_manager.extend (create {WINDOW_PREFERENCES_VIEW})
		end

end
