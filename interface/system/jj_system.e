note
	description: "[
		Root object for use with {JJ_MAIN_WINDOW} which can be placed
		into any number of these windows using the {VIEW} model.
		]"
	date: "21 Apr 06"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/system/jj_system.e $"
	date:		"$Date: 2012-05-31 14:05:35 -0400 (Thu, 31 May 2012) $"
	revision:	"$Revision: 10 $"


class
	JJ_SYSTEM

inherit

	SHARED

create
	default_create

feature {NONE} -- Initialization

	initialize_interface
			-- Set up the interface items into the `interface_table'.
		do
--			interface_table.add_item_with_tuple (<<"{SYSTEM} - System not saved text", "System not saved", "The system has not been saved since last change.", "Changes have been made, but the system has not been save.", "icon_red_cross.ico">>)
--			interface_table.add_item_with_tuple (<<"{SYSTEM} - Not in system text", "Not in system", "The displayed interface names are not used by the program.", "The displayed interface names are not used by the program.", "icon_exec_quit_color.ico">>)
--			interface_table.add_item_with_tuple (<<"{SYSTEM} - Not allowed pixmap", "Not allowed", "Operation not allowed", "The operation you are attempting is not allowed.", "icon_delete_color.ico">>)
--			interface_table.add_item_with_tuple (<<"{SYSTEM} - Empty", "Empty", "Empty view or object", "The view or object is empty.", "icon_class_symbol_gray.ico">>)
		end

end
