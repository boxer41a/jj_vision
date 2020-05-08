note
	description: "[
		A {VIEW} for displaying an {EDITABLE} using it's `schema'
		]"
	date: "30 Mar 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/dialog_editor_view.e $"
	date:		"$Date: 2012-05-31 14:05:35 -0400 (Thu, 31 May 2012) $"
	revision:	"$Revision: 10 $"

class
	DIALOG_EDITOR_VIEW

inherit

	EV_STOCK_COLORS
		rename
			implementation as colors_implementation
		export
			{NONE} all
		undefine
			default_create,
			is_equal,
			copy
		end

	VIEW
		rename
			target_imp as record_imp,
			target as record,
			set_target as set_record
		undefine
--			default_create,
			copy,
			is_equal
		redefine
			create_interface_objects,
			initialize,
			record_imp,
			set_record,
			draw
		end

--	EV_CELL
	EV_FRAME
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
--			data,		-- to make it inaplicable
--			set_data	-- to make it inaplicable
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
			Precursor {EV_FRAME}
			create changed_controls.make
			create controls.make
			create save_actions
			create control_select_actions
			create scrollable_area
			create time_drawn.from_seconds (0)
		end

	initialize
			-- Create an editor view.
		do
			Precursor {EV_FRAME}
			Precursor {VIEW}
			extend (scrollable_area)
			set_save_on_change
			set_actions
		end

	set_actions
			-- Add actions to the widgets
		do
			scrollable_area.item.drop_actions.extend (agent on_drop_editable)
		end

feature -- Access

	scrollable_area: EDITOR_SCROLL_AREA

	schema: detachable SCHEMA
			-- Current schema in use by the editor.

	save_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed after the record is saved.

	control_select_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when a control is clicked.

feature -- Element change

	set_record (a_record: like record)
			-- Change `record' to `a_record'
			-- Reload the data into the controls
		do
			Precursor {VIEW} (a_record)
			draw
		end

	set_schema (a_schema: like schema)
			-- Change `schema' to `a_schema'.
			-- Uses the pattern described in feature `set_target' from VIEW to
			-- add `a_schema' to the `object_set' (the set of objects contained
			-- in this view) and removes the old schema (if it had one) from
			-- the `object_set'.
			-- Also, removes old/add new fields contained in `a_schema'.
		require
			schema_exists: a_schema /= Void
		do
				-- Save the old `record'
			if a_schema /= schema then
				if attached schema as s then
					target_set.prune (s)
					schema := a_schema
					target_set.extend (s)
				end
				draw
			end
		ensure
			schema_assigned: schema = a_schema
			contains_schema: target_set.has (a_schema)
--			old_schema_removed: (old schema /= Void) and (old schema /= schema) implies not target_set.has (old schema)
		end

feature -- Basic operations

	draw
			-- Rebuild and show the view.
		do
			if schema /= Void then
				if is_rebuild_needed then
					build_controls
				end
				if record /= Void then
					fill_controls
					if attached schema as s and then record.has_schema (s) then
						enable_controls
					else
						disable_controls
					end
				else
					disable_controls
				end
			end
		end

	disable
			-- Make the controls unresponsive to input.
		do
			is_user_disabled := True
		end

	enable
			-- Make the controls responsive to input.
		do
			is_user_disabled := False
		end

feature -- Status report

	is_user_disabled: BOOLEAN
			-- Has the user requested the controls to be disabled?

	is_save_on_change: BOOLEAN
			-- Are changes made in the controls automatically
			-- saved to `record'?  In other words, is `record'
			-- updated anytime a change is made, or must it
			-- be done manually with a call to `save_record'?

feature -- Status setting

	set_save_on_change
			-- Make automatic updates to `record' whenever
			-- a change is made in any control.
		do
			is_save_on_change := True
		end

	set_save_on_request
			-- Require `save_record' to be called in order to
			-- accept any changes make in any control.
		do
			is_save_on_change := False
		end

feature -- Basic operations

	disable_controls
			-- Disable all controls.
		local
			c: CONTROL
		do
			from controls.start
			until controls.exhausted
			loop
				c := controls.item
				c.disable_sensitive
				check attached c.parent as p then
					p.set_foreground_color (Red)
					p.propagate_foreground_color
				end
				controls.forth
			end
		end

	enable_controls
			-- Enable all controls.
		local
			c: CONTROL
		do
			from controls.start
			until controls.exhausted
			loop
				c := controls.item
				c.enable_sensitive
				check attached c.parent as p then
					p.set_foreground_color (Black)
					p.propagate_foreground_color
				end
				controls.forth
			end
		end

feature {NONE} -- Implementation

	build_controls
			-- Create controls for each FIELD in `schema'.
		require
			schema_exists: schema /= Void
		local
			f: FIELD
			c: CONTROL
		do
			check attached {EDITOR_FIXED} scrollable_area.item as ef then
					-- Because `scrollable_area' is an {EDITOR_SCROLL_AREA}
					-- which *should* hold an {EDITOR_FIXED}.
				ef.wipe_out
				controls.wipe_out
				if attached schema as s then
					from s.start
					until s.exhausted
					loop
						f := s.field
						c := f.as_widget
							-- add actions to each control as it is created
						c.valid_change_actions.extend (agent on_control_changed (c))
						c.select_actions.extend (agent on_control_selected (c))
		--				c.display.pointer_button_press_actions.force_extend (agent on_control_selected (c))
		--				c.label.pointer_button_press_actions.force_extend (agent on_control_selected (c))
							-- put the control into the fixed
						ef.extend (c)
							-- place the control in the correct spot
						scrollable_area.position_control (c)
							-- keep track of the control
						controls.extend (c)
						if is_user_disabled then
							disable_controls
						end
						s.forth
					end
					if not is_user_disabled then
						enable_controls
					end
				end
			end
			check attached schema as s then
				time_drawn := s.time_modified.twin
			end
		end

	save_record
			-- Get the data from each control and put it into the
			-- the record if the data is valid.
		require
			record_exitsts: record /= Void
		local
			dat: ANY	-- for testing
			con: CONTROL	-- control
			c: EDIT_COMMAND
		do
			from changed_controls.start
			until changed_controls.off
			loop
				con := changed_controls.item
				if con.is_display_valid and then not con.field.is_calculated then
					dat := con.value
					c := new_edit_command (record, con.field, con.value)
						-- Disable drawing to keep this control from being updated
						-- when the EDIT_COMMAND is executed.
					disable_drawing
					command_manager.add_command (c)
					enable_drawing
				end
				changed_controls.forth
			end
			save_actions.call ([])
			changed_controls.wipe_out
		end

	new_edit_command (a_record: like record; a_field: FIELD; a_value: ANY): EDIT_COMMAND
			-- Used by `save_record' to get an EDIT_COMMAND
		require
			record_exists: record /= Void
		do
			create Result.make (a_record, a_field, a_value)
		end

	fill_controls
			-- Put the data from the record into the corresponding control
		require
			record_exists: record /= Void
		local
			key: STRING
			con: CONTROL
		do
			from
				controls.start
			until
				controls.exhausted
			loop
				key := controls.item.field.label
				con := controls.item
				if attached record.value (key) as dat then
					con.set_data (dat)
				end
				con.refresh
				controls.forth
			end
		end

feature {CONTROL} -- implementation

	on_drop_editable (a_editable: EDITABLE)
			-- React to drop of `a_editable' on Current except if
			-- it is a FIELD.  (FIELDs are handled by FIELD_EDITOR_VIEW.)
-- Fix me !!!  This makes the interface inconsistent by allowing a drop
--				of a type that is really not allowed.
		require
			editable_exists: a_editable /= Void
		do
				-- The `parent_tool' (a EDIT_TOOL) takes care of the special
				-- case, when `a_editable' is a FIELD.
			if attached parent_tool as pt then
				pt.set_target (a_editable)
			end
		end

	on_control_changed (a_control: CONTROL)
			-- A change has been made to value in `a_control'
		require
			control_exists: a_control /= Void
		do
			changed_controls.extend (a_control)
			if is_save_on_change then
				save_record
				disable_drawing
				draw_views (record)
				enable_drawing
			end
		end

	on_control_selected (a_control: CONTROL)
			-- React to `a_control' being selected.
		require
			control_exists: a_control /= Void
		do
			control_select_actions.call ([a_control])
		end

feature {NONE} -- Implementation

	controls: LINKED_SET [CONTROL]
			-- All the controls in the pages.

	changed_controls: LINKED_SET [CONTROL]
			-- Controls whose data has changed since last save

	is_rebuild_needed: BOOLEAN
			-- Used internally to let `draw' know that the controls
			-- need to be rebuilt, because the schema has changed
			-- since the last call to `draw'.  This prevents calling
			-- `build_controls' (and unnecessarily recreating the
			-- controls again) on every call to `draw'.
		require
			schema_exists: schema /= Void
		do
			check attached schema as s then
				Result := time_drawn < s.time_modified
			end
		end

	time_drawn: YMDHMS_TIME
			-- The time the controls were last drawn.
			-- This is used to allow the controls for a schema to be
			-- redrawn only after the `schema' has changed, not every
			-- time a new `record' is set.
			-- Updated by `build_controls'.

	record_imp: detachable EDITABLE
			-- Detachable implementation of `target' for void-safety


feature {NONE} -- Inaplicable

--	data: ANY
--			-- Not to be used
--			
--	set_data (a_data: like data) is
--			-- Not to be used
--		do
--			check
--				False
--			end
--		end

end
