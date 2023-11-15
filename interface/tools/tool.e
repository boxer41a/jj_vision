note
	description: "[
		Base class for all the tool windows.  Has history list for
		stepping forward and backward through the `viewable_items'
		which have been displayed in the tool.
		
		The {TOOL} is a EV_FRAME containing an EV_VERTICAL_BOX called
		`main_container'.  Into `main_container' is placed an EV_HORIZONTAL_BOX
		serving as a toolbar called `title_bar'.  (An EV_HORIZONTAL_BOX was
		used instead of a EV_TOOL_BAR in order to add widgets other than
		EV_TOOLBAR_BUTTONS to the toolbar, giving the desired look.)  The
		`title_bar' is built by adding text, buttons, spaces, other bars, etc
		to it.  Below the `title_bar' is added the `cell' from `split_manager'
		which contains any {VIEW}s in the tool.
		
			TNL = `tool_name_label'	-- contains the `name' of the tool
			HTB = `history_tool_bar`	-- contains the forth and back buttons
			TL  = `target_label'		-- shows the name of the object in the tool
			TB  = `tool_bar'			-- clients add buttons here
			UT	= `user_text'		-- an EV_LABEL allowed to expand (see `set_user_text')
			RTB = `resize_tool_bar'	-- contains the minimize/miximize and close buttons
			FB  = `forth_button'		-- To go back in the history
			BB  = `back_button'		-- to go forward in the history
			xB  = `maximize_button' or `restore_button'
			X   = `close_button'
			`bar' = split_manager.bar	-- any buttons produced by `split_manager' are here
			
		  |------------------------------ title bar -----------------------------------|
		  | | TNL |  |--- HTB ---| | TL | |-- TB --|  | `bar' |  | UT |  |--- RTB ---|
		  |          | |BB| |FB| | 		  |  ...   |  |  ...  |          | |xB|  |X| |
		  |----------------------------------------------------------------------------|
		  |                                                                          |
		  |                                                                          |
		  |                               split_manager.cell                         |
		  |																			 |
		  |                                                                          |
		  |----------------------------------------------------------------------------|
		  
		The `bar' and `cell', both from `split_manager', will be empty because no
		{VIEW}s have been added to the `split_manager'.  Descendants should follow this
		pattern as described in class {SPLIT_MANAGER}, redefining `initialize'.
		
		feature initialize is
				-- Set up the window.
				-- Redefine to add the views to the window.
			do
				Precursor {TOOL}
				split_manager.extend (view_one)
				split_manager.extend (view_two)
			end
			
		Feature `initialize' above assumes two features, `view_one' and `view_two',
		to be defined to return a descendant of {VIEW} and some effected EV_WIDGET.
		]"
	date: "30 Sep 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/tools/tool.e $"
	date:		"$Date: 2015-10-24 07:32:40 -0700 (Sat, 24 Oct 2015) $"
	revision:	"$Revision: 23 $"

class
	TOOL

inherit

	SPLIT_VIEW
		undefine
--			default_create,
			copy
		redefine
			create_interface_objects,
			initialize,
			add_actions,
			set_target,
			draw,
			state
		end

	EV_FRAME
		rename
			object_id as ise_object_id
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize,
			destroy,
			is_destroyed
		end

	PIXEL_BUFFERS
		undefine
			default_create,
			copy
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {SPLIT_VIEW}
			Precursor {EV_FRAME}
--			create history
			create history_dropdown
			create main_container
				-- Create the action sequences
			create maximize_actions
			create close_actions
			create restore_actions
				-- Create the buttons
			create title_bar
			create tool_bar
			create history_tool_bar
--			create user_text
			create resize_tool_bar
			create tool_name_label
			create target_label
--			create history_combo		-- see "fix me" comment before `update_history_combo' feature
--			create split_manager
				-- Create buttons
			create back_button
			create forth_button
			create maximize_button
			create restore_button
			create close_button
			size_button := maximize_button
				-- Set button attributes
			back_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_back_color_buffer))
			back_button.set_tooltip ("Back")
			forth_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_forth_color_buffer))
			forth_button.set_tooltip ("Forth")
			maximize_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_maximize_color_buffer))
			maximize_button.set_tooltip ("Maximize")
			restore_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_restore_color_buffer))
			restore_button.set_tooltip ("Restore")
			close_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_close_color_buffer))
			close_button.set_tooltip ("Close")
		end

	initialize
			-- Build the interface for this window
			-- Must create `view' before calling this.
		local
			hs: EV_HORIZONTAL_SEPARATOR
		do
			Precursor {EV_FRAME}
			Precursor {SPLIT_VIEW}
			tools.extend (Current)
				-- Prevent the tool from holding more than one target, so
				-- the history functions will work.
			history_dropdown.set_parent_tool (Current)
			target_label.set_minimum_width (Target_label_width)
--			view_manager.set_single_mode
--			split_manager.disable_mode_changes
				-- Create the toolbar
			build_tool_bars
			build_title_bar
				-- To get the tool bar look I used small 16x16 pixel icons.
				-- The `title_bar' is an EV_HORIZONTAL_BOX which contains several
				-- widets.  These are a EV_LABLE, an EV_TOOL_BAR, another label
				-- (which is allowed to expand), and finally another EV_TOOL_BAR
				-- containing the `minimize_button' or the `restore_button' (depending
				-- on `is_maximized') and the `close_button'.
			main_container.extend (title_bar)
			main_container.disable_item_expand (title_bar)
			create hs
			main_container.extend (hs)
			main_container.disable_item_expand (hs)
			main_container.extend (split_manager.cell)
			extend (main_container)
			set_minimum_height (100)
--			set_view (Default_view)
--			set_button_states
				-- No, do not call `add_actions'; it is already called
				-- from {VIEW}.`initialize' throught {SPLIT_VIEW}
--			add_actions
		end

	build_title_bar
			-- Create the small title bar at top of tool
		local
			lab: EV_LABEL
		do
				-- Add the name of tool to the title bar
			tool_name_label.set_text (generating_type.name)
			title_bar.extend (tool_name_label)
			title_bar.disable_item_expand (tool_name_label)
				-- Add the forth and back buttons (in `history_tool_bar')
			title_bar.extend (history_tool_bar)
			title_bar.disable_item_expand (history_tool_bar)
				-- Add a title to the tool
--			title_bar.extend (target_label)
--			title_bar.disable_item_expand (target_label)
				-- Add a history list combo box
--			history_combo.disable_edit
--			title_bar.extend (history_combo)	-- see "fix me" comment before `update_history_combo' feature
				-- If use EV_COMBO_BOX the title bar must be bigger to
				-- allow for `minimum_height' of the box.
				-- Add the tool bar (to be used in descendants
			title_bar.extend (tool_bar)
			title_bar.disable_item_expand (tool_bar)
				-- Put in a spacer to move the mode buttons to right
			create lab.make_with_text ("         ")
			title_bar.extend (lab)
			title_bar.disable_item_expand (lab)
				-- Add the `bar' from `view_manager' here
			title_bar.extend (split_manager.bar)
--			title_bar.disable_item_expand (split_manager.bar)
				-- Add the maximize/minimize and hide buttons (in `resize_tool_bar')
			title_bar.extend (resize_tool_bar)
			title_bar.disable_item_expand (resize_tool_bar)
		end

	build_tool_bars
			-- Create the tool bar.
		local
			vs: EV_VERTICAL_SEPARATOR
		do
			history_tool_bar.extend (back_button)
			history_tool_bar.extend (forth_button)
			history_tool_bar.extend (target_label)
--			create vs
--			history_tool_bar.extend (vs)
--			history_tool_bar.disable_item_expand (vs)
			resize_tool_bar.extend (size_button)
			resize_tool_bar.extend (close_button)
		end

	add_actions
			-- Add functionality to the buttons.
		do
			Precursor {SPLIT_VIEW}
			target_label.set_pebble_function (agent on_get_target)
				-- Add actions to the buttons.
			maximize_button.select_actions.extend (agent on_maximize)
			restore_button.select_actions.extend (agent on_restore)
			close_button.select_actions.extend (agent on_close)
			back_button.select_actions.extend (agent on_back)
			forth_button.select_actions.extend (agent on_forth)
				-- Add actions to `history'
			history_dropdown.select_actions.extend (agent on_history_item_selected)
			target_label.pointer_button_press_actions.extend (agent on_target_label_selected)
--			target_label.drop_actions.extend (agent on_field_dropped_on_target_label)
				-- see "fix me" comment before `update_history_combo' feature
--			history_combo.select_actions.extend (agent on_history_selected)
				-- Add actions to update any views contained in this tool
-- No.  Don't do this as the tool may contain views which only want to handle a part of the viewable.
-- Passing the wrong kind breaks the contract.  Make each descendent descide what to pass to its children views.
--			viewable_added_action_sequence.extend (agent on_viewable_added)
		end

feature -- Access

	tool_bar: EV_HORIZONTAL_BOX		--EV_TOOL_BAR
			-- Available for adding new buttons in descendants.

	state: TOOL_STATE
			-- Snapshot of the current settings of Current
		do
			create Result.make (Current)
		end

feature -- Element change

	set_target (a_target: like target)
			-- Change the value of `target' and add it to the `object_set' (the set
			-- of objects contained in this view.  The old target is removed from
			-- the set.
		do
			if target_imp /= a_target then
				Precursor {SPLIT_VIEW} (a_target)
--				add_object (a_target.target_label_field)
--				tool_label.set_accept_cursor (a_viewable.accept_cursor)
--				tool_label.set_deny_cursor (a_viewable.deny_cursor)
				update_history
				draw
			end
		end

--	set_user_text (a_string: STRING)
--			-- Change the `user_text'
--		do
--			user_text.set_text (a_string)
--		end

feature {SPLIT_MANAGER, HISTORY_DROPDOWN} -- Access

	tool_name_label: EV_LABEL
			-- String in top left of toolbar to display the name of the tool.

	target_label: EV_LABEL
			-- String in the bar to display the name of the `target'.

	maximize_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when the tool is maximized.

	close_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when the tool is closed.

	restore_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when the tool is restored.

feature -- Element change

--	set_user_text (a_text: STRING_8)
--			-- Change the `user_text' that is displayed in the title bar.
--		do
--			user_text.set_text (a_text)
--		end

feature -- Status report

	is_maximized: BOOLEAN
			-- Is the tool in a maximized state?

	is_resizable: BOOLEAN
			-- Is the tool resizable?  (E.g. is the `resize_tool_bar' visible?)
		do
			Result := resize_tool_bar.is_displayed
		end

	is_destroyed: BOOLEAN
			-- Is `Current' no longer usable?
		do
			Result := not tools.has (Current) and Precursor {EV_FRAME}
		end

feature -- Status setting

	enable_resize
			-- Allow the `resize_tool_bar' to show.
		do
			resize_tool_bar.show
		end

	disable_resize
			-- Hide the `resize_tool_bar'.
		do
			resize_tool_bar.hide
		end

	enable_history
			-- Make the `history_tool_bar' visible
		do
			history_tool_bar.show
--			target_label.show
		end

	disable_history
			-- Make the `history_tool_bar' NOT visible
		do
			history_tool_bar.hide
--			target_label.hide
		end

feature -- Basic operations

	draw
			-- Builds the string shown at top of the tool in `viewable_label'
			-- using the id of the object.
		local
			n: STRING
			s: STRING
			f: EV_FONT
			i: INTEGER
			w: INTEGER	-- for testing
		do
			if is_view_empty then
				n := "Empty"
			else
				if attached {EDITABLE} target as e then
					n := e.display_name
				else
					n := target.generating_type
				end
			end
			f := target_label.font
			create s.make (0)
			from i := 1
			until i > n.count or else f.string_width (s) >= Target_label_width
			loop
				w := f.string_width (s)
				s.append_character (n.item (i))
				i := i + 1
			end
			if f.string_width (s) > Target_label_width then
				s.remove_tail (1)
			end
			target_label.set_text (s)
			target_label.set_tooltip (n)
			set_button_states
		end

	destroy
			-- Destroy underlying native toolkit object.
			-- Render `Current' unusable.
		do
			tools.prune (Current)
			Precursor {EV_FRAME}
		ensure then
			not_in_tool_set: not tools.has (Current)
		end

feature {NONE} -- Actions

--	on_field_dropped_on_target_label (a_field: STRING_FIELD) is
--			-- React to a drop of `a_field' onto the `target_label'.
--		require
--			field_exists: a_field /= Void
--		do
--			target.set_target_label_field (a_field)
--			draw_views (target.target_label_field)
--		end

	on_target_label_selected (a_x, a_y, a_button: INTEGER;
						a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
						a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 then
				history_dropdown.show
			end
		end

	on_history_item_selected
			-- React to an item selection from the `history_dropdown'.
		do
			set_target (selected_history_item_target)
		end

	on_get_target: like target
			-- Used as agent for `target_label.get_pebble_function' because
			-- an attribute cannot be used as an agent
		do
			Result := target
		end

	-- see "fix me" comment before `update_history_combo' feature
--	on_history_selected is
--			-- Handle an item select in the history combo box
--		require
--			history_exists: history /= Void
--		local
--			cli: CLUSTER_LIST_ITEM
--		do
--			cli ?= history_combo.selected_item
--			check
--				cli_not_void: cli /= Void	-- because only CLUSTER_LIST_ITEMS should be in list
--			end
--			set_cluster (cli.cluster)
--		end

	on_back
			-- Handle a go back request (from button or menu).
		require
			history_exists: history_dropdown /= Void
			history_can_go_back: not history_dropdown.is_off and then not history_dropdown.is_before
		local
			v: HISTORY_ITEM
		do
			history_dropdown.back
			v := history_dropdown.item
			check attached {like target} v.target as t then
				set_target (t)
			end
			set_button_states
		end

	on_forth
			-- Handle a go forth request (from button or menu).
		require
			history_exists: history_dropdown /= Void
			history_can_go_forth: not history_dropdown.is_off and then not history_dropdown.is_after
		local
			v: HISTORY_ITEM
		do
			history_dropdown.forth
			v := history_dropdown.item
			check attached {like target} v.target as t then
				set_target (t)
			end
			set_button_states
		end

	on_maximize
			-- React to a request (button or menu) to "maximize" by performing
			-- the actions in `maximize_actions'.
		require
			resizing_allowed: is_resizable
		do
			maximize_actions.call ([])
		end

	on_restore
			-- React to a request (button or menu) to "maximize" by performing
			-- the actions in `maximize_actions'.
		require
			resizing_allowed: is_resizable
		do
			restore_actions.call ([])
		end

	on_close
			-- React to a close request by executing the `close_actions'.
		require
			resizing_allowed: is_resizable
		do
			close_actions.call ([])
		end

feature {SPLIT_MANAGER, TOOL_STATE} -- Actions

	maximize
			-- Put window in maximized state
		require
			resizing_allowed: is_resizable
		do
			is_maximized := True
			if not (size_button = restore_button) then
				resize_tool_bar.go_i_th (resize_tool_bar.index_of (size_button, 1))
				resize_tool_bar.replace (restore_button)
				size_button := restore_button
			end
			close_button.disable_sensitive
		end

	restore
			-- Put window back in default state
		require
--			resizing_allowed: is_resizable
		do
			is_maximized := False
			if not (size_button = maximize_button) then
				resize_tool_bar.go_i_th (resize_tool_bar.index_of (size_button, 1))
				resize_tool_bar.replace (maximize_button)
				size_button := maximize_button
			end
			close_button.enable_sensitive
		end

	close_button: EV_TOOL_BAR_BUTTON
			-- Button containing an "X" icon

	maximize_button: EV_TOOL_BAR_BUTTON
			-- Button which parent can access intended
			-- to be used to maximize the tool.

	restore_button: EV_TOOL_BAR_BUTTON
			-- Button which parent can access intended
			-- to be used to normalize (restore) the tool.

feature {NONE} -- Implementation

	update_history
			-- Update the history list.
		require
			target_exists: target /= Void
		local
			found: BOOLEAN
			v: HISTORY_ITEM
			oldest_v: HISTORY_ITEM
		do
--			if not history.has (viewable) then		-- not needed if history is a SET
				-- does history have viewable?  Must do a search because list items
			from history_dropdown.start
			until found or else history_dropdown.is_exhausted
			loop
				v := history_dropdown.item
				if v.is_simular (new_history_item) then
					found := True
				else
					history_dropdown.forth
				end
			end
			if found then
					-- leave list as is but change time stamp of found item
				v := history_dropdown.item
				v.reset_time_stamp
			else
					-- not found so must add a new one
				v := new_history_item
				history_dropdown.extend (v)
				if history_dropdown.count > maximum_history_items then
						-- find oldest item in list and remove it
					oldest_v := history_dropdown.first
					from history_dropdown.start
					until history_dropdown.is_exhausted
					loop
						v := history_dropdown.item
						if v.time_stamp < oldest_v.time_stamp then
							oldest_v := history_dropdown.item
						end
						history_dropdown.forth
					end
					history_dropdown.start
					history_dropdown.prune (oldest_v)
				end
				history_dropdown.start
				history_dropdown.search (v)
					-- Display a string describing the target
				target_label.set_text (v.target.generating_type.name + " " + v.time_stamp.as_string)
				check
					not_off: not history_dropdown.is_off	-- because just inserted it
				end
			end
--			update_history_combo	-- see "fix me" comment before `update_history_combo' feature
--			set_button_states
--			end
		ensure
			proper_histroy_count: history_dropdown.count <= maximum_history_items
		end

-- Fix me!!!
			-- `update_history_combo' is a problem.
			-- Line "history_combo.wipe_out" causes a system crash, perhaps the screen
			-- objects are not getting destroyed?  Tried destroying each item in combo
			-- but that did not help.
			-- Also, can't seem to set the text; get an infinate loop?
			-- Besides, the combo box is too tall; it make the TOOL's toolbar and buttons
			-- too big, so commenting it out.
--	update_history_combo is
--			-- Put the history items into the `history_combo' box
--		local
--			cli: CLUSTER_LIST_ITEM
--			pos: CURSOR
--			c: CLUSTER
--		do
--			history_combo.wipe_out
--			pos := history.cursor
--			c := history.item.cluster
--			from history.start
--			until history.exhausted
--			loop
--				if history.item.cluster /= c then
--					create cli.make (history.item.cluster)
--					history_combo.extend (cli)
--				end
--				history.forth
--			end
--			history.go_to (pos)
--			history_combo.enable_edit	-- so set_text will work
--			history_combo.set_text (history.item.cluster.id)
--			history_combo.disable_edit
--		end

	set_button_states
			-- Set the states of the back and forth buttons.
		do
			if history_dropdown.is_empty or history_dropdown.is_first or history_dropdown.is_before then
				back_button.disable_sensitive
			else
				back_button.enable_sensitive
			end
			if history_dropdown.is_empty or history_dropdown.is_last or history_dropdown.is_after then
				forth_button.disable_sensitive
			else
				forth_button.enable_sensitive
			end
			if history_dropdown.is_empty then
				target_label.disable_sensitive
			else
				target_label.enable_sensitive
			end
		end

	main_container: EV_VERTICAL_BOX
			-- Holds the other widgets in the TOOL.

	title_bar: EV_HORIZONTAL_BOX
			-- Holds the name of tool, `history_tool_bar', and `resize_tool_bar'.

	history_tool_bar: EV_HORIZONTAL_BOX	--EV_TOOL_BAR
			-- The toolbar with the forth, back and posibly history buttons.

--	user_text: EV_LABEL
--			-- Text settable by `set_user_text'

	resize_tool_bar: EV_TOOL_BAR
			-- Tool bar to hold resize and close buttons

feature {NONE} -- Implementation

	forth_button: EV_BUTTON	--EV_TOOL_BAR_BUTTON
			-- Button containing go back icon

	back_button: EV_BUTTON	--EV_TOOL_BAR_BUTTON
			-- Button containing go forth icon

	size_button: EV_TOOL_BAR_BUTTON
			-- Button containing maximize or restore icon

--	history_combo: EV_COMBO_BOX		-- see "fix me" comment before `update_history_combo' feature
			-- To pull down a history list

	maximum_history_items: INTEGER = 5
			-- Number of items to keep in history list

feature {HISTORY_DROPDOWN} -- Implementation

	history_dropdown: HISTORY_DROPDOWN
			-- A dropdown-like box containing the clusters previously targetted
			-- in this tool from which selections can be made to retarget the tool.

	new_history_item: HISTORY_ITEM
			-- Helper routine called by `update_history' when it needs to
			-- create a new time-stamped viewable for placement in the `history'.
			-- Made a seperate routine because descendents may want to store
			-- other types of items in the history list.
		do
			create Result.make (target)
		end

	selected_history_item_target: like target
			-- The item from the `history_dropdown' typecast to `target'
		do
			check attached {HISTORY_ITEM} history_dropdown.selected_item as hi then
				check attached {like target} hi.target as t then
					Result := t
				end
			end
		ensure
			Result_exists: Result /= Void
		end

feature {TOOL} -- Implementation

	tools: LINKED_SET [TOOL]
			-- Keeps track of all the TOOLs in the system
		once
			create Result.make
		end

feature {NONE} -- Constants

	Target_label_width: INTEGER = 100
			-- Sets the size of the `target_label' in pixels.

invariant

	close_button_exists: close_button /= Void
	restore_button_exists: restore_button /= Void
	maximize_button_exists: maximize_button /= Void

--	label_clickable_when: history.is_empty implies not object_label.is_sensitive

end
