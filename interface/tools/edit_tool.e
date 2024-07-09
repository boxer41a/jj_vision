note
	description: "[
		A {TOOL} used to hold views for editting an {EDITABLE}
		]"
	date: "23 Feb 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/tools/edit_tool.e $"
	date:		"$Date: 2013-04-25 18:11:22 -0400 (Thu, 25 Apr 2013) $"
	revision:	"$Revision: 14 $"

class
	EDIT_TOOL

inherit

	TOOL
		redefine
			create_interface_objects,
			initialize,
			add_actions,
			target_imp,
			set_target
--			history_dropdown,
--			new_history_item
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
			create list_editor_view
			create dialog_editor_view
			create field_editor_view
				-- Create the new buttons before Precursor {TOOL} so `initialize'
				-- can call `set_actions' without a Void reference.
			create edit_schema_toggle_button
			create schema_label
			create new_field_button
			create delete_field_button
			create align_fields_button
			edit_schema_toggle_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_shell_color_buffer))
			edit_schema_toggle_button.set_tooltip ("EDIT_TOOL.edit_schema_toggle_button")
			new_field_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_shell_color_buffer))
			new_field_button.set_tooltip ("EDIT_TOOL.new_field_button")
			delete_field_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_shell_color_buffer))
			delete_field_button.set_tooltip ("EDIT_TOOL.delete_field_button")
			align_fields_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_shell_color_buffer))
			align_fields_button.set_tooltip ("EDIT_TOOL.align_fields_button")
				-- Align_fields menu
			create align_fields_menu
			create align_on_edit_box_check_item
			create align_fields_left_item
			create align_fields_right_item
			create align_fields_top_item
			create align_fields_bottom_item
			create align_fields_horizontal_center_item
			create align_fields_vertical_center_item
				-- New field menu
			create new_field_menu
			create new_string_field_item
			create new_integer_field_item
			create new_date_field_item
				-- Use default schema at first
			create schema
		end

	initialize
			-- Set up the window
			-- Create the views in the window using agents.
		local
			vs: EV_VERTICAL_SEPARATOR
		do
			build_align_fields_menu
			build_new_field_menu
				-- Create the tool and its views
			Precursor {TOOL}
				-- Add `schema_label' to the `title_bar'.
			check
				title_bar_has_target_label: title_bar.has (target_label)
					-- because Precursor {TOOL} should have put it there.
			end
			title_bar.start
			title_bar.search (tool_name_label)
			create vs
			title_bar.put_right (schema_label)
			title_bar.disable_item_expand (schema_label)
			title_bar.put_right (vs)
			title_bar.disable_item_expand (vs)
				-- Add the buttons to the `tool_bar' (from TOOL)
			tool_bar.extend (edit_schema_toggle_button)
				-- Create the views
			split_manager.set_horizontal
			split_manager.extend_siblings (field_editor_view, dialog_editor_view)
			split_manager.set_vertical
			split_manager.extend_siblings (split_manager.last_view, list_editor_view)
				-- Set up the views in this tool.
			split_manager.enable_mode_changes
			split_manager.set_split_mode
			split_manager.disable_view (field_editor_view)
		end

--	initialize_interface
--			-- Add interface items for this class to the `interface_table'.
--		do
--			Precursor {TOOL}
--			interface_table.add_item_with_tuple (<<"{EDIT_TOOL}", "EDIT_TOOL", "This is an EDIT_TOOL.", "This tool is used to create schemas.", "icon_tool_color.ico">>)
--			interface_table.add_item_with_tuple (<<"{EDIT_TOOL}.edit_schema_toggle_button", "Toggles schema build mode", "Click this button to tobble between schema building and normal view", "This tool is used to create schemas.", "icon_tool_color.ico">>)
--			interface_table.add_item_with_tuple (<<"{EDIT_TOOL}.new_field_button", "Create a new field", "Open a drop-down menu for adding fields.", "This button opens a drop-down menu for creating new fields.", "icon_exe_up_to_date.ico">>)
--			interface_table.add_item_with_tuple (<<"{EDIT_TOOL}.delete_field_button", "Delete field", "Delete the selected fields", "This button deletes the selected fields from the schema.", "icon_exec_quit_color.ico">>)
--			interface_table.add_item_with_tuple (<<"{EDIT_TOOL}.align_fields_button", "Align fields", "Align the selected fields.", "This button pulls down a menu for aligning fields in various methods.", "icon_format_clickable_color.ico">>)

--			interface_table.add_item_with_tuple (<<"{EDIT_TOOL} - new_string_field", "Create a STRING field", "Create a STRING field", "Creates a new field of type STRING.", "icon_display_labels_color.ico">>)
--			interface_table.add_item_with_tuple (<<"{EDIT_TOOL} - new_integer_field", "Create an INTEGER field", "Create an INTEGER field", "Creates a new field of type INTEGER.", "icon_once_symbol.ico">>)
--			interface_table.add_item_with_tuple (<<"{EDIT_TOOL} - new_date_field", "Create a DATE field", "Create a DATE field", "Creates a new field of type DATE.", "icon_new_editor_color.ico">>)
--		end

	build_align_fields_menu
			--  Build the `align_fields_menu'.
		do
				-- put items into the menu
			align_fields_menu.extend (align_on_edit_box_check_item)
			align_fields_menu.extend (align_fields_left_item)
			align_fields_menu.extend (align_fields_right_item)
			align_fields_menu.extend (align_fields_top_item)
			align_fields_menu.extend (align_fields_bottom_item)
			align_fields_menu.extend (align_fields_horizontal_center_item)
			align_fields_menu.extend (align_fields_vertical_center_item)
		end

	build_new_field_menu
			-- Build the `new_field_menu'
		do
				-- Put the items into the menu
			new_field_menu.extend (new_string_field_item)
			new_field_menu.extend (new_integer_field_item)
			new_field_menu.extend (new_date_field_item)
		end

	add_actions
			-- Add actions to the widgets
		do
			Precursor {TOOL}
				-- Set actions for buttons and menus
			edit_schema_toggle_button.select_actions.extend (agent on_edit_schema_toggle_button_pressed)
			new_field_button.select_actions.extend (agent on_new_field_button_pressed)
			new_string_field_item.select_actions.extend (agent on_create_new_string_field)
			new_date_field_item.select_actions.extend (agent on_create_new_date_field)
			new_integer_field_item.select_actions.extend (agent on_create_new_integer_field)
			delete_field_button.select_actions.extend (agent on_delete_field)
				-- Set actions for views
			dialog_editor_view.control_select_actions.extend (agent on_control_selected)
				-- Reminder:  Though the `target_label' is part of TOOL, the ability to
				-- change the "field" displayed in the label is only changable from
				-- a system using this [EDIT_TOOL] class.
			tool_name_label.drop_actions.extend (agent on_set_target_label_field)
		end

feature -- Access

	selected_control: detachable CONTROL
			-- The control last selected by the user in "schema-edit" mode.

	list_editor_view: LIST_EDITOR_VIEW
			-- View in list format for editting the schema.

	dialog_editor_view: DIALOG_EDITOR_VIEW
			-- View for editting a record.

	field_editor_view: FIELD_EDITOR_VIEW
			-- View for editting specific fields from the record's schema.

feature -- Element change

	set_target (a_target: like target)
			-- Change `target' and pass it on to the views.
		do
				-- Must handle a FIELD differently.
			if attached {FIELD} a_target as f then
				if is_edit_schema_mode then
					field_editor_view.set_record (f)
				end
			else
				Precursor {TOOL} (a_target)
				list_editor_view.set_record (a_target)
				dialog_editor_view.set_record (a_target)
				dialog_editor_view.set_schema (get_schema)
				draw
			end
		end

feature -- Status report

	is_edit_schema_mode: BOOLEAN
			-- Is the tool in a mode to allow changes to the schema?

feature {NONE} -- Implementation (actions)

	on_edit_schema_toggle_button_pressed
			-- React to a press of the edit_schema_toggle_button' by
			-- toggling between "schema-edit" mode and "normal" mode.
		do
			if edit_schema_toggle_button.is_selected then
					-- Add the `field_editor_view'.
				split_manager.enable_view (field_editor_view)
				split_manager.set_split_mode
				split_manager.disable_mode_changes
				dialog_editor_view.control_select_actions.resume
					-- Add the buttons
				tool_bar.extend (new_field_button)
				tool_bar.extend (delete_field_button)
				tool_bar.extend (align_fields_button)
				is_edit_schema_mode := True
			else
					-- Remove the `field_editor_view'.
				split_manager.enable_mode_changes
				split_manager.disable_view (field_editor_view)
				dialog_editor_view.control_select_actions.block
					-- Remove the buttons
				tool_bar.start
				tool_bar.prune (new_field_button)
				tool_bar.start
				tool_bar.prune (delete_field_button)
				tool_bar.start
				tool_bar.prune (align_fields_button)
				is_edit_schema_mode := False
			end
		end

	on_control_selected (a_control: CONTROL)
			-- A control has been selected in "schema-edit" mode.
			-- Added as agent to `dialog_editor_view.control_selected_actions' in
			-- feature `on_edit_schema_toggle_button_pressed'.
		require
			control_exists: a_control /= Void
		do
			selected_control := a_control
			field_editor_view.set_record (a_control.field)
			field_editor_view.set_schema (a_control.field.schema)
			syncronize_buttons
		ensure
			control_was_selected: selected_control = a_control
			field_was_set: field_editor_view.record = a_control.field
		end

	on_new_field_button_pressed
			-- React to a press of the `new_field_button'.
		do
			new_field_menu.show
		end

	on_create_new_string_field
			-- React to a menu item or button used to create a new string field.
		local
			f: STRING_FIELD
			c: CHANGE_FIELDS_COMMAND
		do
			create f
			create c.make (schema, f)
			command_manager.add_command (c)
		end

	on_create_new_date_field
			-- React to a menu item or button used to create a new date field.
		local
			f: YMD_TIME_FIELD
			c: CHANGE_FIELDS_COMMAND
		do
			create f
			create c.make (schema, f)
			command_manager.add_command (c)
		end

	on_create_new_integer_field
			-- React to a menu item or button used to create a new integer field.
		local
			f: INTEGER_FIELD
			c: CHANGE_FIELDS_COMMAND
		do
			create f
			create c.make (schema, f)
			command_manager.add_command (c)
		end

	on_delete_field
			-- Remove the selected field from the schema.
		require
			is_deletable: not target.schema.has_mandatory (field_editor_view.record)
		local
			f: FIELD
			c: CHANGE_FIELDS_COMMAND
		do
			if not field_editor_view.is_view_empty then
				f := field_editor_view.record
				create c.make (schema, f)
				c.set_delete_action
				command_manager.add_command (c)
			end
		end

	on_set_target_label_field (a_field: STRING_FIELD)
			-- Change the "global" field to be used to determine what part of
			-- an EDITABLE (based on `a_field') to display in the drop-downs
			-- and lists, etc.  (See `set_target_label_field' from EDITABLE.)
		require
			field_exists: a_field /= Void
		local
			e: EDITABLE
		do
				-- Because `target_label_field' is a once feature just need to
				-- make sure it is called; to do that I need an EDITABLE.
			create e
			e.set_target_label_field (a_field)
		end


feature {FIELD_EDITOR_VIEW} -- Implementation

	get_schema: SCHEMA
			-- Obtain a schema from the `record'
		require
			target_exists: target /= Void
		do
			if target.schema /= schema then
				Result := target.schema
				schema := Result
			else
				Result := schema
			end
		ensure
			result_exists: result /= Void
		end

feature {NONE} -- Implementation

	target_imp: detachable EDITABLE
			-- Detachable implementation of `target' for void-safety

	schema: SCHEMA
			-- The last schema used and passed to the views.

	syncronize_buttons
			-- Make sure the buttons are in the correct state.
		local
			f: FIELD
		do
			f := field_editor_view.record
			if schema.has_mandatory (f) then
				delete_field_button.disable_sensitive
			else
				delete_field_button.enable_sensitive
			end
		end

feature {NONE} -- Implementation (buttons)

	edit_schema_toggle_button: EV_TOGGLE_BUTTON  --EV_TOOL_BAR_TOGGLE_BUTTON
			-- Toggles between normal mode and a mode allowing
			-- editting of the `schema' from `record'.

	schema_label: EV_LABEL
			-- Shows the `id' or name of the schema currently in use.

	align_fields_button: EV_BUTTON  --EV_TOOL_BAR_BUTTON
			-- Aligns a group of fields

	delete_field_button: EV_BUTTON  --EV_TOOL_BAR_BUTTON
			-- Deletes the selected field(s) from the `schema' of `record'

	new_field_button: EV_BUTTON --EV_TOOL_BAR_BUTTON
			-- Pulls down a menu for creating a new field

	new_field_menu: EV_MENU
			-- Pull down menu for selecting the type of field
			-- activated by the `new_field_button'.

	new_string_field_item: EV_MENU_ITEM
			-- Used to create a new STRING_FIELD

	new_integer_field_item: EV_MENU_ITEM
			-- Used to create a new INTEGER_FIELD

	new_date_field_item: EV_MENU_ITEM
			-- Used to create a new YMD_TIME_FIELD

	align_fields_menu: EV_MENU
			-- Pull down menu for selecting the field alignment method,
			-- activated by the `align_field_button'.

	align_on_edit_box_check_item: EV_CHECK_MENU_ITEM
			-- Select to make allignments key off the edit boxes of the
			-- selected controls as opposed to the labels.

	align_fields_left_item: EV_MENU_ITEM
			-- Align the left sides of the selected controls

	align_fields_right_item: EV_MENU_ITEM
			-- Align the right sides of the selected controls

	align_fields_top_item: EV_MENU_ITEM
			-- Align the tops of the selected controls

	align_fields_bottom_item: EV_MENU_ITEM
			-- Align the bottoms of the selected controls

	align_fields_horizontal_center_item: EV_MENU_ITEM
			-- Align the horizontal centers of the selected controls

	align_fields_vertical_center_item: EV_MENU_ITEM
			-- Align the vertical centers of the selected controls

invariant

	has_schema_if_has_record: target_imp /= Void implies schema /= Void
	has_correct_schema: target_imp /= Void implies target.has_schema (schema)

end
