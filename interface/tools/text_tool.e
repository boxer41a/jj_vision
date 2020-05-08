note
	description: "[
		A {TOOL} that holds a {TEXT_VIEW} in which to edit a long string
		]"
	date: "4 Jan 08"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/tools/text_tool.e $"
	date:		"$Date: 2013-06-16 13:26:06 -0700 (Sun, 16 Jun 2013) $"
	revision:	"$Revision: 15 $"

class
	TEXT_TOOL

inherit

	TOOL
		redefine
			create_interface_objects,
			initialize,
			build_tool_bars,
			add_actions
--			view
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {TOOL}
			create clear_button
			create view
			clear_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_shell_color_buffer))
			clear_button.set_tooltip ("{EDIT_TOOL}.clear_button")
		end

	initialize
			-- Build the interface for this window
		do
			Precursor {TOOL}
			split_manager.extend (view)
		end

	build_tool_bars
			-- Create the two toolbars.
		do
			Precursor {TOOL}
			tool_bar.extend (clear_button)
			tool_bar.extend (create {EV_TOOL_BAR_SEPARATOR})
		end

	add_actions
			-- Adds agents to the buttons and menues.
		do
			Precursor {TOOL}
			clear_button.pointer_button_press_actions.force_extend (agent clear)
		end

feature {NONE} -- Implementation

	clear
			-- delete all text
		do
			view.remove_text
		end

	clear_button: EV_TOOL_BAR_BUTTON
			-- Button to move to previous record

	view: TEXT_VIEW
			-- Text area for displaying ships info, etc.

end
