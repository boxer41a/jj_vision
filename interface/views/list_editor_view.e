note
	description: "[
		A {VIEW} which allows the editting of an {EDITABLE} in a
		multi-column list.
		]"
	date: "24 Feb 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/list_editor_view.e $"
	date:		"$Date: 2012-05-31 14:05:35 -0400 (Thu, 31 May 2012) $"
	revision:	"$Revision: 10 $"

class
	LIST_EDITOR_VIEW

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

	EV_NOTEBOOK
		rename
			item as page,
			selected_item as selected_page,
			select_item as select_page,
			set_item_text as set_page_text
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
--			data,
--			set_data
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
			record_imp
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
			Precursor {EV_NOTEBOOK}
			create changed_controls.make
			create controls.make
			create save_actions
			create control_select_actions
		end

	initialize
			-- Create an editor view.
		do
			Precursor {VIEW}
			Precursor {EV_NOTEBOOK}
			set_save_on_change
			set_actions
		end

	set_actions
			--
		do
			drop_actions.extend (agent on_drop_object)
--			selection_actions.extend (agent on_page_selected)
		end

feature -- Access

--	record: EDITABLE
			-- The object that contains the data to be editted.
			-- Data in `record' is reached via feature `value (a_key)'.

	schema: detachable SCHEMA
			-- Describes how to build the controls which
			-- will be used to edit `record'.

	save_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed after the record is saved.

	control_select_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when a control is clicked.

feature -- Element change

	set_schema (a_schema: like schema)
			-- Change `schema' to `a_schema'.
		require
			schema_exists: a_schema /= Void
		do
			if schema /= a_schema then
				schema := a_schema
				build_pages
				if record /= Void then
					fill_controls
				end
			end
			if record = Void then
				disable_controls		-- at least until user loads a record
			end
		ensure
			schema_was_set: schema = a_schema
		end

	set_target (a_record: like record)
			-- Change `record' to `a_record'
			-- Reload the data into the controls
		require
			record_exists: a_record /= Void
		do
			record_imp := a_record
			if not is_user_disabled then
				enable_controls
			end
			fill_controls
		ensure
			record_was_set: record = a_record
		end

feature -- Basic operations

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

feature {NONE} -- Implementation (actions)

	on_drop_object (a_object: like record)
			-- React to `a_object' dropping on Current.
		require
			object_exists: a_object /= Void
		local
--			p: DATABASE_EDIT_TOOL
		do
--			p ?= parent
--			if p /= Void then
--				parent_tool.set_object (a_object)			
--			end
	end

feature {NONE} -- Implementation

	build_pages
			-- Create a tab in the notebook for each schema_page in `schema'.
--		local
----			ep: EDITOR_PAGE
----			sa: EV_SCROLLABLE_AREA
--			sa: EDITOR_SCROLL_AREA
--			ef: EDITOR_FIXED
--			sp: SCHEMA_PAGE
--			f: FIELD
--			c: CONTROL
		do
--			wipe_out
--			from schema.start
--			until schema.exhausted
--			loop
--					-- for each SCHEMA_PAGE in `schema', make a scroll
--					-- area and put it in Current (an EV_NOTEBOOK).  This
--					-- will create a tabbed page for each page in the schema.
--				create sa
--				extend (sa)
--				select_page (sa)
--				sp := schema.item
--				set_page_text (sa, sp.name)
--					-- For each FIELD in the SCHEMA_PAGE create a CONTROL
--					-- and put it into the 'fixed' from EDITOR_SCROLL_AREA.
--				from sp.start			
--				until sp.exhausted
--				loop
--						-- create a control from the field
--					f := sp.item
--					c := f.as_widget
--						-- add actions to each control as it is created
--					c.display.change_actions.extend (agent on_control_changed (c))
--					c.display.pointer_button_press_actions.force_extend (agent on_control_selected (c))
--					c.label.pointer_button_press_actions.force_extend (agent on_control_selected (c))
--						-- put the control into the fixed
--					sa.item.extend (c)
--						-- place the control in the correct spot
--					sa.position_control (c)
--						-- keep track of the control
--					controls.extend (c)
--					sp.forth
--				end
--				if is_user_disabled then
--					disable_controls
--				end
--				schema.forth
--			end
--			if record /= Void then
--				fill_controls
--			end
		end

	save_record
			-- Get the data from each control and put it into the
			-- the record if the data is valid.
		require
			record_exitsts: record /= Void
		local
			dat: ANY	-- COMPARABLE		-- data
			con: CONTROL	-- control
		do
			from changed_controls.start
			until changed_controls.off
			loop
				con := changed_controls.item
				if con.is_display_valid and then not con.field.is_calculated then
					dat := con.value
					record.extend_value (dat, con.field.id)
				end
				changed_controls.forth
			end
			save_actions.call ([])
			changed_controls.wipe_out
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
				key := controls.item.field.id
				con := controls.item
				if attached record.value (key) as dat then
					con.set_data (dat)
				end
				con.refresh
				controls.forth
			end
		end

feature {CONTROL} -- implementation

	on_control_changed (a_control: CONTROL)
			-- A change has been made to value in `a_control'
		do
			changed_controls.extend (a_control)
			if is_save_on_change then
				save_record
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

invariant

	invariant_clause: -- Your invariant here

end
