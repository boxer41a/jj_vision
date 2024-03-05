note
	description: "[
		This can be used as base class for the main window(s) of a program, 
		allowing the program to have multiple main windows, with a standard 
		set of buttons and actions such as undo/redo, open, save, etc.
		
		
		To enable undo/redo create a descendant of {JJ_COMMAND} and add it to the 
		`command_mangaer' with `add_command'.
		]"
	date: "18 Jul 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2015, Jimmy J. Johnson"
	license:		"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/system/jj_main_window.e $"
	date:		"$Date: 2015-10-24 07:32:40 -0700 (Sat, 24 Oct 2015) $"
	revision:	"$Revision: 23 $"

class
	JJ_MAIN_WINDOW

inherit

	VIEW
		undefine
--			default_create,
			copy
		redefine
			create_interface_objects,
			initialize,
			draw,
			state,
--			set_split_manager,
			add_actions
		end

	EV_TITLED_WINDOW
		rename
			object_id as ise_object_id,
			item as ev_item,
			is_empty as ev_is_empty
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end

	PIXEL_BUFFERS
		undefine
			default_create,
			copy
		end

create
	make

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			create split_manager
				-- Create the "File" menu
			create file_menu
			create file_new_target_item
			create file_save_item
			create file_open_item
			create file_exit_item
				-- Create the "Edit" menu
			create edit_menu
			create edit_undo_item
			create edit_redo_item
				-- Create the "Tools" menu
			create tool_menu
			create tool_preferences_item
				-- Create the "Window" menu
			create window_menu
			create window_new_item
			create window_maximize_all_item
			create window_minimize_all_item
			create window_raise_all_item
				-- Create the "Help" menu
			create help_menu
			create help_about_item
				-- Create the `jj_menu_bar'
			create jj_menu_bar
				-- Create the main_window box and tool bar
			create jj_tool_bar
			create jj_tool_bar_box
			create jj_tool_bar
			create new_target_button
			create open_button
			create save_button
			create undo_button
			create redo_button
			create new_window_button
			create minimize_all_button
			create raise_all_button
			create help_button
--				-- Create the status bar.
--			create jj_status_bar
--			create jj_status_label
				-- Create the dialogs
			create preferences_dialog
			Precursor {VIEW}
			Precursor {EV_TITLED_WINDOW}
		end

	initialize
			-- Build the interface for this window.
--		local
--			sys: like system
		do
--			create split_manager
			Precursor {EV_TITLED_WINDOW}
			Precursor {VIEW}
			main_windows.extend (Current)
				-- Create and add the menu bar.
			build_standard_menu_bar
			show_menu
				-- Create and add the toolbar.
			build_main_window_tool_bar
			upper_bar.extend (create {EV_HORIZONTAL_SEPARATOR})
			upper_bar.extend (jj_tool_bar_box)
			upper_bar.extend (create {EV_HORIZONTAL_SEPARATOR})
				-- Create and add the status bar.
--			build_standard_status_bar
--			lower_bar.extend (jj_status_bar)
				-- Set up window attributes
--			set_system (sys)		-- commented out for dynamic editor
--			set_target (system)
			set_size (Window_width, Window_height)
--			set_actions
--			set_widget_states
			set_preferences_dialog (Default_preferences_dialog)
				-- Set up the "split-managed" cell, bar, and menu.
			extend (split_manager.cell)
			jj_tool_bar_box.extend (split_manager.bar)
			window_menu.extend (split_manager.menu)
				-- Finish the window
			set_title (Window_title)
--			draw
		end

	add_actions
			-- Add actions to the widgets
		do
				-- add actions to window
			close_request_actions.extend (agent on_close_window)
				-- add actions to File menu items
			file_new_target_item.select_actions.extend (agent on_make_new_target)
			file_open_item.select_actions.extend (agent on_file_open)
			file_save_item.select_actions.extend (agent on_file_save)
			file_exit_item.select_actions.extend (agent on_exit)
				-- add actions to the Tool menu items
			tool_preferences_item.select_actions.extend (agent on_show_preferences_dialog)
				-- add actions to Window menu items
			window_new_item.select_actions.extend (agent on_make_new_window)
			window_maximize_all_item.select_actions.extend (agent on_maximize_all)
			window_minimize_all_item.select_actions.extend (agent on_minimize_all)
			window_raise_all_item.select_actions.extend (agent on_raise_all)
--			window_preferences_item.select_actions.extend (agent on_show_preferences_window)
				-- add actions to Help menu items
			help_about_item.select_actions.extend (agent on_about)
				-- add actions to buttons
			new_target_button.set_pebble_function (agent on_get_target)
			new_target_button.select_actions.extend (agent on_make_new_target)
			new_target_button.drop_actions.extend (agent on_drop_target)
--			open_button.select_actions.extend (agent on_file_open)
--			save_button.select_actions.extend (agent on_file_save)
			undo_button.select_actions.extend (agent command_manager.undo)
			redo_button.select_actions.extend (agent command_manager.execute)
			new_window_button.drop_actions.extend (agent on_drop_in_new_window)
			new_window_button.select_actions.extend (agent on_make_new_window)
			minimize_all_button.select_actions.extend (agent on_minimize_all)
			raise_all_button.select_actions.extend (agent on_raise_all)
--			preferences_button.select_actions.extend (agent on_show_preferences_window)
		end

	build_standard_menu_bar
			-- Create and populate `jj_menu_bar'.
		do
				-- Add attributes to menu items
			file_menu.set_text ("File")
			file_new_target_item.set_text ("New target")
			file_save_item.set_text ("Save")
			file_open_item.set_text ("Open")
			file_exit_item.set_text ("Exit")
			edit_menu.set_text ("Edit")
			edit_undo_item.set_text ("Undo")
			edit_redo_item.set_text ("Redo")
			tool_menu.set_text ("Tool")
			tool_preferences_item.set_text ("Preferences")
			window_menu.set_text ("Window")
			window_new_item.set_text ("New")
			window_maximize_all_item.set_text ("Maximize all")
			window_minimize_all_item.set_text ("Minimize all")
			window_raise_all_item.set_text ("Raise all")
			help_menu.set_text ("Help")
			help_about_item.set_text ("About")
				-- Register and fill the "File" menu
			file_menu.extend (file_new_target_item)
			file_menu.extend (file_open_item)
			file_menu.extend (file_save_item)
			file_menu.extend (create {EV_MENU_SEPARATOR})
			file_menu.extend (file_exit_item)
				-- Register and fill the "Edit" menu
			edit_menu.extend (edit_undo_item)
			edit_menu.extend (edit_redo_item)
				-- Register and fill the "Tools" menu
			tool_menu.extend (tool_preferences_item)
				-- Register and fill the "Window" menu
			window_menu.extend (window_new_item)
			window_menu.extend (window_maximize_all_item)
			window_menu.extend (window_minimize_all_item)
			window_menu.extend (window_raise_all_item)
				-- Register and fill the "Help" menu
			help_menu.extend (help_about_item)
				-- Fill the `jj_menu_bar'
			jj_menu_bar.extend (file_menu)
			jj_menu_bar.extend (edit_menu)
			jj_menu_bar.extend (tool_menu)
			jj_menu_bar.extend (window_menu)
			jj_menu_bar.extend (help_menu)
		ensure
			menu_bar_created:
				jj_menu_bar /= Void and then
				not jj_menu_bar.is_empty
		end

	build_main_window_tool_bar
			-- Create and populate the standard toolbar.
		local
			lab: EV_LABEL
		do
				-- Add attributes to buttons
			new_target_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_object_symbol_buffer))
			new_target_button.set_tooltip ("New target")
			open_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_open_file_color_buffer))
			open_button.set_tooltip ("Open")
			save_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_save_color_buffer))
			save_button.set_tooltip ("Save")
			undo_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_undo_color_buffer))
			undo_button.set_tooltip ("Undo")
			redo_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_redo_color_buffer))
			redo_button.set_tooltip ("Redo")
			new_window_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_new_development_tool_color_buffer))
			new_window_button.set_tooltip ("New window")
			minimize_all_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_minimize_all_color_buffer))
			minimize_all_button.set_tooltip ("Minimize all")
			raise_all_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_restore_all_color_buffer))
			raise_all_button.set_tooltip ("Raise all")
			help_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_help_tool_color_buffer))
			help_button.set_tooltip ("Help")
				-- Add the buttons to the toolbar
			jj_tool_bar.extend (new_target_button)
			jj_tool_bar.extend (open_button)
			jj_tool_bar.extend (save_button)
			jj_tool_bar.extend (create {EV_TOOL_BAR_SEPARATOR})
			jj_tool_bar.extend (undo_button)
			jj_tool_bar.extend (redo_button)
			jj_tool_bar.extend (create {EV_TOOL_BAR_SEPARATOR})
			jj_tool_bar.extend (new_window_button)
			jj_tool_bar.extend (minimize_all_button)
			jj_tool_bar.extend (raise_all_button)
			jj_tool_bar.extend (create {EV_TOOL_BAR_SEPARATOR})
			jj_tool_bar.extend (help_button)
			jj_tool_bar.extend (create {EV_TOOL_BAR_SEPARATOR})
				-- Add the tool bar to the box
			jj_tool_bar_box.extend (jj_tool_bar)
			jj_tool_bar_box.disable_item_expand (jj_tool_bar)
				-- Add some space after the `help_button'
			create lab.make_with_text ("     ")
			jj_tool_bar_box.extend (lab)
			jj_tool_bar_box.disable_item_expand (lab)
		ensure
			toolbar_created: jj_tool_bar /= Void and then  not jj_tool_bar.is_empty
		end

--	build_standard_status_bar
--			-- Create and populate the status bar at bottom of window.
--		do
--			jj_status_bar.set_border_width (2)
--			jj_status_label.align_text_left
--			jj_status_bar.extend (jj_status_label)
--		ensure
--			status_bar_created:
--				jj_status_bar /= Void and then
--				jj_status_label /= Void
--		end

feature -- Access

	state: MAIN_WINDOW_STATE
			-- Used to `persist' the state of the widget.
			-- Redefined as attribute so it gets stored with the object.
			-- Call `make_state' to create a new state from Current.
		do
			create Result.make (Current)
		end

feature -- Status report

	is_cancelled: BOOLEAN_REF
			-- Was an action (in a dialog) cancelled?
			-- A once function so any JJ_MAIN_WINDOW can recognize it.
		once
			create Result
		end

feature -- Status setting

	cancel
			-- A cancel button in one of the dialogs was pressed.
			-- Sets `is_cancelled' to True.
			-- Should be reset to False after it is checked.
		do
			is_cancelled.set_item (True)
		end

	uncancel
			-- Resets is_cancelled to False
		do
			is_cancelled.set_item (False)
		end

feature -- Element change

--	restore_with_state (a_state: MAIN_WINDOW_STATE) is
--			-- Set up window parameters as read from a file with name `a_file_name'.
--			-- `A_file_name' should include the full path and name of the file.
--		require
--			state_exists: a_state /= Void
--		local
--			t: like target
--		do
--			t ?= a_state.target
--			if t /= Void then
--				set_target (t)
--			end
--			set_position (a_state.x, a_state.y)
--			if a_state.is_maximized then
--				maximize
--			elseif a_state.is_minimized then
--				minimize
--			else
--				restore
--			end
--			set_size (a_state.width, a_state.height)
--			split_manager.restore_with_state (a_state.split_manager_state)
--		end

	show_menu
			-- Show the menu bar
		do
			set_menu_bar (jj_menu_bar)
		end

	hide_menu
			-- Hide the menu bar
		do
			remove_menu_bar
		end

	show_button_text
			-- Show text on all the buttons
		do
--			view_manager.show_button_text
--			interface_table.show_button_text
		end

	hide_button_text
			-- Show text on all the buttons
		do
--			view_manager.hide_button_text
--			interface_table.hide_button_text
		end

	set_preferences_dialog (a_window: EV_TITLED_WINDOW)
			-- Make `a_window' available to Current so `a_window' can be shown
			-- when the `preferences_button' or `preferences_item' is selected.
		require
			window_exists: a_window /= Void
		do
			preferences_dialog := a_window
		ensure
			window_registered: preferences_dialog = a_window
		end

--	set_status_text (a_text: STRING_8)
--			-- Change the text in the status bar.
--		do
--			jj_status_label.set_text (a_text)
--		end

feature -- Basic operations

	draw
			-- Update the whole window.
		local
			s: STRING
		do
				-- This simply puts the `display_name' (from EDITABLE) or `generating_type' of
				-- the `target' into the title bar of the window.
			check attached {JJ_APPLICATION} (create {EV_ENVIRONMENT}).application as app then
					-- Because {JJ_MAIN_WINDOW} (this class) is for use in a {JJ_APPLICATION}.
				s := app.generating_type + ":  "
				if not is_view_empty then
					if attached {EDITABLE} target as e then
						s := s + e.display_name.to_string_8
					else
						s := s + target.generating_type.name
					end
				else
					s := s + "Empty"
				end
				set_title (s)
				set_widget_states
			end
		end

	frozen ask_to_save
			-- Show the `ask_to_save_dialog'
		do
--			check attached {JJ_APPLICATION} (create {EV_ENVIRONMENT}).application as a then
--					-- because only {JJ_APPLICATION} should use this.  really ???
--				w := a.first_window
--				ask_to_save_dialog.show_modal_to_window (a.first_window)
--			end
			ask_to_save_dialog.show_modal_to_window (Current)
		end

	show_save_dialog
			-- Show the `file_save_dialog'.
			-- Also, passed as an agent in `ask_to_save_dialog'.
		do
			file_save_dialog.show_modal_to_window (main_windows.first)
		end

	validate_file_name_and_save
			-- Get a file name and write `save_object' to disk.
		require
--			save_object_exists: save_object.item /= Void
		local
			s: STRING
			f: RAW_FILE
		do
			s := file_save_dialog.file_title
			if is_valid_file_name (s) then
				create f.make_open_write (s)
				f.general_store (target)
			else
				file_save_dialog.show_modal_to_window (main_windows.first)
			end
		end

	validate_file_name_and_open
			-- Get a file name and read a object into `save_object'
		require
--			save_object_exists: save_object.item /= Void
		local
			s: STRING
			f: RAW_FILE
		do
			s := file_open_dialog.file_name
			if is_valid_file_name (s) then
				create f.make_open_read (s)
				if attached f.retrieved as a then
					if attached {like target_imp} a as t then
						set_target (t)
					end
				end
--				if attached {like target_imp} f.retrieved as t then
----					set_save_object (a)
--					target_imp := t
--				end
			else
				file_open_dialog.show_modal_to_window (main_windows.first)
			end
		end

feature {NONE} -- Actions

	on_show_preferences_dialog
			-- React to a press of the preferences button or menu by
			-- showing the `preferences_dialog'.
		require
			preferences_dialog_exists: preferences_dialog /= Void
		do
			preferences_dialog.show
			if preferences_dialog.is_minimized then
				preferences_dialog.restore
			end
			preferences_dialog.raise
		end

	on_file_open
			-- React to a request to read a system from disk.
		do
			validate_file_name_and_open
			set_widget_states
		end

	on_file_save
			-- React to a request to save the system to disk.
		local
			w: JJ_MAIN_WINDOW
--			ff: STANDARD_INTERFACE_FILE_FACILITIES
		do
--			create ff
--			ff.set_persistent (system)
--			ff.validate_file_name_and_save
--			set_save_object (target)
			validate_file_name_and_save
--			if system.is_okay then
					-- Change the title of all JJ_MAIN_WINDOWs targeted
					-- to `target'
				from main_windows.start
				until main_windows.exhausted
				loop
					w := main_windows.item
					if w.target = target then
						w.draw
					end
					main_windows.forth
				end
--			else
--				-- save operation failed.  Write failure?
--			end
--			set_widget_states
		end

	on_get_target: like target
			-- Needed to be able to `set_pebble_function' for buttons so the
			-- button can pick the current `target' as a pebble during a pick.
		do
			Result := target
		end

	on_make_new_target
			-- Create a new target after querying user to save
			-- current target if necessary.
		local
			t: like target
		do
			create t
			set_target (t)
--			draw
		end

	on_about
			-- Display the About dialog.
		do
			about_dialog.show
		end

	on_maximize_all
			-- Maximize all the main windows
		do
			main_windows.do_all (agent {JJ_MAIN_WINDOW}.maximize)
		end

	on_minimize_all
			-- Minimize all the main windows
		do
			main_windows.do_all (agent {JJ_MAIN_WINDOW}.minimize)
		end

	on_raise_all
			-- Raise all the main windows
		do
			main_windows.do_all (agent {JJ_MAIN_WINDOW}.restore)
		end

	on_drop_in_new_window (a_target: like target)
			-- React to `a_target' drop on the new_window button.
		require
			target_exists: a_target /= Void
		local
			w: like Current
		do
			create w.make (a_target)
			w.show
		end

	on_drop_target (a_target: like target)
			-- React to drop of `a_target' (on a button?) by changing
			-- the `target' and setting up views.
		require
			target_exists: a_target /= Void
		do
--			system.uncancel
--			system.ask_to_save
--			if not system.is_cancelled.item then
--				set_system (a_system)
--			end
		end

	on_make_new_window
			-- Create a new JJ_MAIN_WINDOW (like Current) and
			-- target it to the same `system'.
		local
			w: like Current
		do
			create w.make (target)
			w.show
		end

	on_exit
			-- End the execution, insuring to save unsaved targets.
		local
			w: JJ_MAIN_WINDOW
		do
			from main_windows.start
			until main_windows.exhausted or else is_cancelled.item
			loop
				w := main_windows.item
				if not is_view_empty then
--					set_save_object (w.target)
					ask_to_save
				end
				main_windows.forth
			end
			if not is_cancelled.item then
				end_application
			end
		end

feature {JJ_MAIN_WINDOW, APPLICATION_STATE} -- Implementation (support routines)

	on_close_window
				-- A request to close the window has occured.
				-- If this is the only window displaying `system' then give user
				-- chance to save the `system' before closing window.
				-- Remove the `a_window' from `main_windows' list and destroy it.
				-- If it is the last window then end the application.
		do
			uncancel
			check attached {JJ_APPLICATION} (create {EV_ENVIRONMENT}).application as jj_app then
					-- Because {JJ_MAIN_WINDOW} (this class) is for use in a {JJ_APPLICATION}.
--			if jj_app.persistence_manager.is_pending then
				ask_to_save
--			end
				if not is_cancelled.item then
					if main_windows.count = 1 then
							-- About to close the last window and therefore end the application,
							-- so save it's state before destroying this last window.
						end_application
					else
						main_windows.start
						main_windows.prune (Current)
						destroy
					end
				end
			end
		end

feature {COMMAND_MANAGER} -- Implementation

	set_widget_states
			-- Update the state of the buttons and menu items
		do
				-- Item always enabled
--			file_menu.enable_sensitive
--			file_new_system_item.enable_sensitive
--			file_open_item.enable_sensitive
--			file_exit_item.enable_sensitive
--			help_menu.enable_sensitive
--			help_about_item.enable_sensitive
--			new_window_button.enable_sensitive
--			new_system_button.enable_sensitive
--			open_button.enable_sensitive
--			help_button.enable_sensitive
				-- Items conditionally enabled
			if is_view_empty then
				file_save_item.disable_sensitive
				save_button.disable_sensitive
			elseif command_manager.is_at_marked_state then
				file_save_item.disable_sensitive
				save_button.disable_sensitive
			else
				file_save_item.enable_sensitive
				save_button.enable_sensitive
			end

			if command_manager.is_undoable then
				edit_undo_item.enable_sensitive
				undo_button.enable_sensitive
			else
				edit_undo_item.disable_sensitive
				undo_button.disable_sensitive
			end
			if command_manager.is_executable then
				edit_redo_item.enable_sensitive
				redo_button.enable_sensitive
			else
				edit_redo_item.disable_sensitive
				redo_button.disable_sensitive
			end
		end

feature {NONE} -- Implementation (support routines)

	is_target_in_other_window: BOOLEAN
			-- Is `target' also contained in some other JJ_MAIN_WINDOW?
			-- Used to determine if it must be saved when Current is closed.
		do
			if target /= Void then
				from main_windows.start
				until main_windows.exhausted or else Result
				loop
					Result := main_windows.item /= Current and then main_windows.item.target = target
					main_windows.forth
				end
			end
		end

	end_application
			-- Close down the application
		do
			if attached (create {EV_ENVIRONMENT}).application as a then
				a.destroy
			end
		end

	preferences_dialog: EV_TITLED_WINDOW
			-- The window, if any, displayed when the `preferences_button' or
			-- `preferences_item' is selected.
			-- Can be used as a dialog for setting up the views.

	Default_preferences_dialog: PREFERENCES_WINDOW
			-- For setting window parameters
		once
--			create Result.make (target)
			create Result
			Result.close_request_actions.extend (agent Result.hide)
		end

feature {NONE} -- Implementation (dialogs)

	about_dialog: ABOUT_DIALOG
			-- Show minimal information about the program.
		once
			create Result
				-- Hide when something else is clicked so it can be non-modal
				-- and so the user does not have to hit the "okay" button or
				-- explicitely close the dialog.
			Result.close_request_actions.extend (agent Result.hide)
			Result.focus_out_actions.extend (agent Result.hide)
		end

	File_open_dialog: EV_FILE_OPEN_DIALOG
			-- Standard
		once
			create Result
--			Result.filters.extend (["*.*", "All files"])
			Result.open_actions.extend (agent validate_file_name_and_open)
			Result.cancel_actions.extend (agent cancel)
		end

	Ask_to_save_dialog: EV_QUESTION_DIALOG
			-- Asks the user if he wants to save the system.
		local
			dc: EV_DIALOG_CONSTANTS
		do
			create dc
			create Result
--			Result.set_text ("System is not saved!%N%N  Save?")
--			Result.button (dc.Ev_yes).select_actions.extend (agent show_save_dialog)
			Result.set_text ("Some objects have changed!  Commit changes?")
			Result.button (dc.ev_yes).select_actions.extend (agent commit_changes)
			Result.button (dc.Ev_cancel).select_actions.extend (agent cancel)
		end

	commit_changes
			-- Save any changed objects.
		do
			check attached {JJ_APPLICATION} (create {EV_ENVIRONMENT}).application as jj_app then
					-- Because this is used by JJ_APPLICATIONs
--				jj_app.persistence_manager.commit
			end
		end

	File_save_dialog: EV_FILE_SAVE_DIALOG
			-- Standard
		once
			create Result
--			Result.filters.extend (["*.*", "All files"])
			Result.save_actions.extend (agent validate_file_name_and_save)
			Result.cancel_actions.extend (agent cancel)
		end

feature {NONE} -- Menus

	jj_menu_bar: EV_MENU_BAR
			-- Standard menu bar for this window.

	file_menu: EV_MENU
			-- "File" menu for this window (contains New, Open, Close, Exit...)

	file_new_target_item: EV_MENU_ITEM
			-- "File/New system"

	file_open_item: EV_MENU_ITEM
			-- "File/Open"

	file_save_item: EV_MENU_ITEM
			-- "File/Save"

	file_exit_item: EV_MENU_ITEM
			-- "File/Exit"

	edit_menu: EV_MENU
			-- "Edit" menu (contains Undo, Redo, Cut, Copy, etc...)

	edit_undo_item: EV_MENU_ITEM
			-- "Edit/Undo"

	edit_redo_item: EV_MENU_ITEM
			-- "Edit/Redo"

	tool_menu: EV_MENU
			-- "Tools" menu (contains Preferences, etc...)

	tool_preferences_item: EV_MENU_ITEM
			-- "Tools/Preferences"

	window_menu: EV_MENU
			-- "Window" menu for this window (contains Minimize all, Raise all, etc...)

	window_new_item: EV_MENU_ITEM
			-- "Window/New"

	window_maximize_all_item: EV_MENU_ITEM
			-- "Window/Maximize all"

	window_minimize_all_item: EV_MENU_ITEM
			-- "Window/Minimize all"

	window_raise_all_item: EV_MENU_ITEM
			-- "Window/Raise all"

	help_menu: EV_MENU
			-- "Help" menu for this window (contains About...)

	help_about_item: EV_MENU_ITEM
			-- "Help/About"

feature {NONE} -- Toolbars and buttons

	jj_tool_bar_box: EV_HORIZONTAL_BOX
			-- Holder for `jj_tool_bar'.  Other items can
			-- be added here to make a custom bar or to `upper_bar'
			-- to place another tool_bar below this one.

	jj_tool_bar: EV_TOOL_BAR
			-- Standard toolbar for this window

	new_window_button: EV_TOOL_BAR_BUTTON
			-- Create a new system

	new_target_button: EV_TOOL_BAR_BUTTON
			-- Create a new system for this window

	open_button: EV_TOOL_BAR_BUTTON
			-- Opens an existing system

	save_button: EV_TOOL_BAR_BUTTON
			-- To save the system

	minimize_all_button: EV_TOOL_BAR_BUTTON
			-- To minimize all the JJ_MAIN_WINDOWs

	raise_all_button: EV_TOOL_BAR_BUTTON
			-- To restore all the JJ_MAIN_WINDOWs

	help_button: EV_TOOL_BAR_BUTTON
			-- Opens help engine

	undo_button: EV_TOOL_BAR_BUTTON
			-- To undo the last command

	redo_button: EV_TOOL_BAR_BUTTON
			-- To redo the last undone command

feature {NONE} -- Status bar

--	jj_status_bar: EV_STATUS_BAR
--			-- Standard status bar for this window

--	jj_status_label: EV_LABEL
--			-- Label situated in the `jj_status_bar'.
--			-- Note: Call `set_status_text' to change the text
--			--       displayed in the status bar.

feature {NONE} -- Implementation

	split_manager: SPLIT_MANAGER
			-- Controls placement of sub-windows

feature {NONE} -- Implementation / Constants

	Window_title: STRING = "JJ_MAIN_WINDOW"
			-- Title of the window.

	Window_width: INTEGER = 800
			-- Initial width for this window.

	Window_height: INTEGER = 600
			-- Initial height for this window.

invariant

--	system_exists: system /= Void

end

