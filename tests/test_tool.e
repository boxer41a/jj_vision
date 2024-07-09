note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2013-04-25 18:11:22 -0400 (Thu, 25 Apr 2013) $"
	revision: "$Revision: 14 $"

class
	TEST_TOOL

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
			create go_previous_button
			create go_next_button
			go_previous_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_shell_color_buffer))
			go_previous_button.set_tooltip ("TEST_TOOL.go_previous_button")
			go_next_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_shell_color_buffer))
			go_next_button.set_tooltip ("TEST_TOOL.go_next_button")
			create view.make ("Test String")
		end

	initialize
			-- Build the interface for this window
		do
			Precursor {TOOL}
			main_container.extend (view)
		end

	build_tool_bars
			-- Create the two toolbars.
		do
			Precursor {TOOL}
				-- Place buttons in toolbar
			tool_bar.extend (go_previous_button)
			tool_bar.extend (go_next_button)
			tool_bar.extend (create {EV_HORIZONTAL_SEPARATOR})
		end

	add_actions
			-- Add functionality to the buttons
		do
			Precursor {TOOL}
--			go_previous_button.select_actions.extend (agent on_go_previous_button_pressed)
--			go_next_button.select_actions.extend (agent on_go_next_button_pressed)
		end

feature -- Access

	view: JJ_MODEL_WORLD_CELL_VIEW
			-- The view controlled by this tool

feature {NONE} -- Implementation

	go_previous_button: EV_BUTTON	--EV_TOOL_BAR_BUTTON
			-- Button to move to previous record

	go_next_button: EV_BUTTON	--EV_TOOL_BAR_BUTTON
			-- Button to move to next record

end
