note
	description: "[
		A {VIEW} placed in a {PREFERENCES_WINDOW} for setting the
		startup and appearance attributes of a {JJ_MAIN_WINDOW}
		]"
	date: "12 Sep 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/window_preferences_view.e $"
	date:		"$Date: 2015-10-24 07:32:40 -0700 (Sat, 24 Oct 2015) $"
	revision:	"$Revision: 23 $"

class
	WINDOW_PREFERENCES_VIEW

inherit

	SHARED
		undefine
			default_create,
			is_equal
		end

	FIXED_VIEW
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
			Precursor {FIXED_VIEW}
			create apply_to_label
			create apply_to_combo_box
			create hide_menu_check_button
			create hide_button_text_check_button
			create button_size_label
			create button_size_spin_button.make_with_value_range (create
					{INTEGER_INTERVAL}.make (Minimum_pixmap_size, Maximum_pixmap_size))
			create language_combo_box
			create start_up_options_label
			create height_label
			create height_spin_button
			create width_label
			create width_spin_button
			create x_position_label
			create x_position_spin_button
			create y_position_label
			create y_position_spin_button
			create mode_label
			create mode_combo_box
		end

	initialize
			-- Set up the dialog
		do
			Precursor {FIXED_VIEW}
			hide_menu_check_button.align_text_left
			hide_button_text_check_button.align_text_right
--			height_spin_button.align_text_left
--			width_spin_button.align_text_left
--			x_position_spin_button.align_text_left
--			y_position_spin_button.align_text_left

			extend (apply_to_label)
			extend (apply_to_combo_box)
			extend (hide_menu_check_button)
			extend (hide_button_text_check_button)
			extend (button_size_label)
			extend (button_size_spin_button)
			extend (language_combo_box)
			extend (start_up_options_label)
			extend (height_label)
			extend (height_spin_button)
			extend (width_label)
			extend (width_spin_button)
			extend (x_position_label)
			extend (x_position_spin_button)
			extend (y_position_label)
			extend (y_position_spin_button)
			extend (mode_label)
			extend (mode_combo_box)

			build_widgets
			set_actions
		end

feature {NONE} -- Basic operations

	build_widgets
			-- Set the apperance and location of all the controls
		local

		do
-- Fix so it looks up these interface items
			apply_to_label.set_text ("Apply these changes to")
			apply_to_combo_box.extend (create {EV_LIST_ITEM}.make_with_text ("All"))
			apply_to_combo_box.extend (create {EV_LIST_ITEM}.make_with_text ("New"))
			hide_menu_check_button.set_text ("Hide menu bar")
			hide_button_text_check_button.set_text ("Hide button text")
			language_combo_box.set_text ("English")
			start_up_options_label.set_text ("Start-up options")
			height_label.set_text ("Height")
			width_label.set_text ("Width")
			x_position_label.set_text ("X position")
			y_position_label.set_text ("Y position")
			mode_label.set_text ("Select mode")
			button_size_label.set_text ("Button size")

			set_item_position (apply_to_label, Spacing, Spacing)
			set_item_position (apply_to_combo_box,
							apply_to_label.x_position + apply_to_label.width + Spacing,
							apply_to_label.y_position)
			set_item_position (hide_menu_check_button,
							Spacing,
							apply_to_combo_box.y_position + apply_to_combo_box.height + Spacing)
			set_item_position (hide_button_text_check_button,
							Spacing,
							hide_menu_check_button.y_position + hide_menu_check_button.height + Spacing)
			set_item_position (button_size_label,
								Spacing,
								hide_button_text_check_button.y_position + hide_button_text_check_button.height + Spacing)
			set_item_position (button_size_spin_button,
							button_size_label.x_position + button_size_label.width + Spacing,
							button_size_label.y_position)
			set_item_position (language_combo_box,
							Spacing,
							button_size_spin_button.y_position + button_size_spin_button.height + Spacing)
			set_item_position (start_up_options_label,
							Spacing,
							language_combo_box.y_position + language_combo_box.height + Spacing)
			set_item_position (height_label,
								Spacing + Spacing,
								start_up_options_label.y_position + start_up_options_label.height + 2)
			set_item_position (height_spin_button,
								height_label.x_position + height_label.width + Spacing,
								height_label.y_position)
			set_item_position (width_label,
								Spacing + Spacing,
								height_spin_button.y_position + height_spin_button.height + Spacing)
			set_item_position (width_spin_button,
								height_spin_button.x_position,
								width_label.y_position)
			set_item_position (x_position_label,
								height_spin_button.x_position + height_spin_button.width + Spacing + Spacing,
								height_label.y_position)
			set_item_position (x_position_spin_button,
								x_position_label.x_position + x_position_label.width + Spacing,
								x_position_label.y_position)
			set_item_position (y_position_label,
								x_position_label.x_position,
								width_label.y_position)
			set_item_position (y_position_spin_button,
								y_position_label.x_position + y_position_label.width + Spacing,
								y_position_label.y_position)
			set_item_position (mode_label,
								Spacing,
								width_label.y_position + width_label.height + Spacing + Spacing)
			set_item_position (mode_combo_box,
								mode_label.x_position + mode_label.width + Spacing,
								mode_label.y_position)
		end

	set_actions
			-- Add agents to the controls
		do
			hide_menu_check_button.select_actions.extend (agent on_hide_menu_option_changed)
			hide_button_text_check_button.select_actions.extend (agent on_hide_button_text_check_button_changed)
			button_size_spin_button.change_actions.extend (agent on_button_size_spin_button_changed)
		end

feature {NONE} -- Basic operations

	on_hide_menu_option_changed
			-- React to a change of the `hide_menu_check_button' by showing ro hiding
			-- the menu bar in all the main windows in the system
		local
			mw: JJ_MAIN_WINDOW
		do
			from main_windows.start
			until main_windows.exhausted
			loop
				mw := main_windows.item
				if not hide_menu_check_button.is_selected and then mw.menu_bar = Void then
					mw.show_menu
				else
					mw.hide_menu
				end
				main_windows.forth
			end
		end

	on_hide_button_text_check_button_changed
			-- React to a change of the `hide_button_text_check_button' by showing or hiding
			-- text on all the buttons in the systems `main_windows'.
		local
			mw: JJ_MAIN_WINDOW
		do
			from main_windows.start
			until main_windows.exhausted
			loop
				mw := main_windows.item
				if hide_button_text_check_button.is_selected then
					mw.hide_button_text
				else
					mw.show_button_text
				end
				main_windows.forth
			end
		end

	on_button_size_spin_button_changed (a_value: INTEGER)
			-- React to a change of the `button_size_spin_button' by changing the
			-- size of the toolbar buttons in the system's `main_window'.
		do
			io.put_string ("Fix me!  WINDOW_PREFERENCES_VIEW.on_button_size_spin_button_changed %N")
		end

feature {NONE} -- Implementation

	apply_to_label: EV_LABEL
			-- Label to go with `apply_to_combo_box'

	apply_to_combo_box: EV_COMBO_BOX
			-- Apply settings to one or all windows in system

	hide_menu_check_button: EV_CHECK_BUTTON
			-- Check to show main menu

	hide_button_text_check_button: EV_CHECK_BUTTON
			-- Check to display text along with the pixmaps on buttons.

	button_size_label: EV_LABEL
			-- Label to go with `button_size_spin_button'.

	button_size_spin_button: EV_SPIN_BUTTON
			-- Sets the size of the pixmaps (and consequently the size of the buttons).

	language_combo_box: EV_COMBO_BOX
			-- Select the language to use

	start_up_options_label: EV_LABEL
			-- Simply a heading saying "Start up options".

	height_label: EV_LABEL
			-- Label to go with `height_spin_button'

	height_spin_button: EV_SPIN_BUTTON
			-- Sets the start-up height of a MAIN_WINDOW

	width_label: EV_LABEL
			-- Label to go with `height_spin_button'

	width_spin_button: EV_SPIN_BUTTON
			-- Sets the start-up width of a MAIN_WINDOW

	x_position_label: EV_LABEL
			-- Label to to with `x_position_spin_button

	x_position_spin_button: EV_SPIN_BUTTON
			-- Sets the start-up `x_position' of a MAIN_WINDOW

	y_position_label: EV_LABEL
			-- Label to to with `y_position_spin_button

	y_position_spin_button: EV_SPIN_BUTTON
			-- Sets the start-up `y_position' of a MAIN_WINDOW

	mode_label: EV_LABEL
			-- Label to go with `mode_combo_box'

	mode_combo_box: EV_COMBO_BOX
			-- Select the start-up mode of a MAIN_WINDOW

feature {NONE} -- Implementation (constants)

	Spacing: INTEGER = 10

end
