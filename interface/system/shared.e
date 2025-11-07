note
	description: "[
		Global objects for use in the "jj_vision" cluster
		]"
	date: "10 May 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/system/shared.e $"
	date:		"$Date: 2015-10-15 13:03:35 -0700 (Thu, 15 Oct 2015) $"
	revision:	"$Revision: 21 $"

class
	SHARED

inherit

	ANY

	JJ_FILE_FACILITIES

feature -- Access, restricted to descendants

	main_windows: LINKED_LIST [JJ_MAIN_WINDOW]
			-- List of all open {JJ_MAIN_WINDOW}s
		once
			create Result.make
		end

	command_manager: COMMAND_MANAGER
			-- Used to undo/redo commands for this system
		once
			create Result
		end

	view_manager: VIEW_MANAGER
			-- Access to {VIEW}s in use in the application
		once
			create Result
		end

feature -- Access

	minimum_pixmap_size: INTEGER = 8
	maximum_pixmap_size: INTEGER = 64

end

