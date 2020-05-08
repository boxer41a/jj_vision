note
	description: "[
		Used to store the appearance of a {TOOL}
		]"
	date: "13 Oct 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/tool_state.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"
	
class
	TOOL_STATE

inherit

	VIEW_STATE
		redefine
			make,
			set_view_attributes,
			new_view
		end

create
	make

feature {NONE} -- Initialization

	make (a_tool: TOOL)
			-- Initialize `Current'.
		do
			Precursor {VIEW_STATE} (a_tool)
			is_maximized := a_tool.is_maximized
			is_resizable := a_tool.is_resizable
		end

feature -- Access

	set_view_attributes
			-- Create a TOOL from the attributes of Current
		do
			if is_maximized then
				view.maximize
			else
				view.restore
			end
			if is_resizable then
				view.enable_resize
			else
				view.disable_resize
			end
		end

feature {NONE} -- Implementation

	is_maximized: BOOLEAN
			-- Holds the value of a tools `is_maximized' feature.

	is_resizable: BOOLEAN
			-- Holds the value of a tools `is_resizable' feature.

	new_view: TOOL
			-- Create a new tool
		do
			create Result
		end

end
