note
	description	: "[
		This sets up buttons and menus for "selecting" multiple views and different
		formats for those views within a `cell'.  The `cell', `menu', and `bar' can
		then be added to your container as appropriate.

		It manages the placement of VIEWs in a `cell', allowing nested
		split areas to be hidden/shown using buttons and/or menus.  The views are placed
		in `cell' which can be placed in an EV_CONTAINER.

		Views are added to Current using `extend' or `extend_siblings'.  Class JJ_MAIN_WINDOW
		has a feature `split_manager' (inherited from VIEW) which allows the placement of
		multiple panes (e.g. VIEWs, TOOLs, etc) into the window.  The `split_manager'
		controls the layout of these VIEWs.  The `initialize' feature from a class descended
		from JJ_MAIN_WINDOW may look like this

		feature initialize is
				-- Set up a window with three VIEWs.
			do
				Precursor {JJ_MAIN_WINDOW}
					-- Allow the user to choose if the children are displayed
					-- as tabs, multiple panes, or as a single cell.
				split_manager.enable_mode_changes
					-- Add two VIEWs to be displayed in an EV_VERTICAL_SPLIT_AREA (when
					-- the window mode `is_split_mode'.)
				split_manager.set_vertical
				split_manager.extend (view_one)
				split_manager.extend (view_two)
					-- Add a third view into an EV_HORIZONTAL_SPLIT_AREA with the
					-- previouse two views (contained in the EV_VERTICAL_SPLIT_AREA)
					-- below the new one
				split_manager.extend_siblings (view_three, split_manager.last_item)
					-- NOTE:  a tool bar and menu items are automatically added.
			end

		If the number of views added to Current is at least two then the `bar' is filled
		with a set of buttons and 'menu' is built with menu items for selecting the
		"mode" of the `cell'.  When `is_in_split_mode' (the default mode) a number of
		views will be displayed in EV_SPLIT_AREAs, recursively, within `cell'.  When
		`is_maximized_mode' only the `selected_view' will be placed in `cell'.  Finally,
		when `is_notebook_mode' the views will be displayed as tabs in an EV_NOTEBOOK
		within `cell'.

		Here is how the `bar' looks when `is_maximized_mode' or `is_notebook_mode'.

			PB = `preferences_button'
			SB = `split_button'
			MB = `maximize_button'
			NB = `notebook_button'
			RB = an EV_TOOL_BAR_RADIO_BUTTON

		  |---------------------- bar --------------------------------------|
		  | |--- mode_bar ---|  |--------------- radio bar -------------|   |
		  | |  |SB| |MB| |NB|   |  |  |RB| |RB| ... to number of views  |   |
		
		When one of the radio buttons is pressed the corresponding view is brought to
		the top.

		When `is_split_mode' the radio buttons are replaced with EV_TOOL_BAR_TOGGLE_BUTTONs.

			TB = an EV_TOOL_BAR_TOGGLE_BUTTON

		  |------------------------------- bar ---------------------------|
		  | |--- mode_bar ---|  |-------------- toggle bar -----------|   |
		  | | |SB| |MB| |NB| |  |   |TB| |TB| ... to number of views  |   |

		When a toggle button is selected the corresponding view becomes visible in a split
		area calculated on the fly.

		The items in `menu' are kept in parallel with the buttons, allowing menu selection
		to accomplish the same things as the buttons.
		]"
	date: "12 Nov 07"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/system/split_manager.e $"
	date:		"$Date: 2014-05-31 08:53:58 -0400 (Sat, 31 May 2014) $"
	revision:	"$Revision: 17 $"

class
	SPLIT_MANAGER

inherit

	SHARED
		export
			{NONE} all
		redefine
			default_create
		end

	S_TREE
		redefine
			default_create,
			root,
			set_root,
			extend,
			extend_siblings
		end

	PIXEL_BUFFERS
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Initialize current
		do
			Precursor {S_TREE}
				-- create exported widgets
			create bar
			create menu
			create cell

--			create root.make (default_view)
			last_node := root
			selected_node := root
--			view := default_view
				-- Assume split mode
			is_split_mode := True
				-- Only need these widgets if more than one view is added.
			create notebook
				-- create tool bars
			create toggle_bar
			create radio_bar
			create mode_bar
				-- create buttons and menus
			create single_mode_button
			create split_mode_button
			create notebook_mode_button
			create mode_menu
			create toggle_menu
			create radio_menu
			create single_mode_item
			create split_mode_item
			create notebook_mode_item
				-- Set widget attributes
			single_mode_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_format_text_color_buffer))
			single_mode_button.set_tooltip ("Single mode")
			split_mode_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_new_development_tool_color_buffer))
			split_mode_button.set_tooltip ("Split mode")
			notebook_mode_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_folders_color_buffer))
			notebook_mode_button.set_tooltip ("Tab mode")
				-- Set up the `mode_bar' and its buttons.
--			mode_bar.extend (create {EV_TOOL_BAR_SEPARATOR})
			mode_bar.extend (single_mode_button)
			mode_bar.extend (split_mode_button)
			mode_bar.extend (notebook_mode_button)
--			mode_bar.extend (create {EV_TOOL_BAR_SEPARATOR})
			split_mode_button.enable_select
				-- Set up menus which do not change
			menu.set_text ("Views")
			mode_menu.set_text ("Mode")
			radio_menu.set_text ("Select view")
			toggle_menu.set_text ("Select view")
			single_mode_item.set_text ("Maximize Mode")
			split_mode_item.set_text ("Split Mode")
			notebook_mode_item.set_text ("Notebook Mode")
			mode_menu.extend (single_mode_item)
			mode_menu.extend (split_mode_item)
			mode_menu.extend (notebook_mode_item)
			split_mode_item.enable_select
				-- Actions for `notebook'
			notebook.selection_actions.extend (agent on_tab_selected)
				-- Actions for buttons
--			preferences_button.select_actions.extend (agent on_show_preferences_dialog)
			split_mode_button.select_actions.extend (agent set_split_mode)
			single_mode_button.select_actions.extend (agent set_single_mode)
			notebook_mode_button.select_actions.extend (agent set_notebook_mode)
				-- Actions for menu items
--			preferences_item.select_actions.extend (agent on_show_preferences_dialog)
			single_mode_item.select_actions.extend (agent set_single_mode)
			split_mode_item.select_actions.extend (agent set_split_mode)
			notebook_mode_item.select_actions.extend (agent set_notebook_mode)
		end

feature -- Access

	cell: EV_CELL
			-- The container which will be managed.  The views will be placed
			-- into `cell' based on the user's button, or menu selections.
			-- This should be extended into a widget.

	menu: EV_MENU
			-- Menu of items to toggle views on and off.
			-- Can be inserted into window menu.

	bar: EV_HORIZONTAL_BOX
			-- Bar of buttons used to manage views.
			-- Can be inserted into a toolbar.

	selected_view: detachable VIEW
			-- The currently selected view.
		do
			if attached selected_node as sn then
				Result := sn.view
			end
		end

	view_count: INTEGER
			-- The number of VIEWs contained in and managed by Current.
		do
			Result := descendents.count
		end

	visible_count: INTEGER
			-- The number of VIEWs which are visible.
		local
			s: like leaf_nodes
			n: like root
		do
			s := leaf_nodes
			from s.start
			until s.exhausted
			loop
				n := s.item
				if n.is_visible then
					Result := Result + 1
				end
				s.forth
			end
		end

	first_visible_view: VIEW
			-- The first view which is visible.
		local
			s: like leaf_nodes
			n: like root
			l_result: detachable VIEW
		do
			s := leaf_nodes
			from s.start
			until l_result /= Void or else s.exhausted
			loop
				n := s.item
				if n.is_visible then
					l_result := n.view
				end
				s.forth
			end
			if l_result = Void then
				Result := Default_view
			else
				Result := l_result
			end
		ensure
			result_exists: Result /= Void
		end

	default_view: DEFAULT_VIEW
			-- Create an EV_LABEL as a place holder
		do
			create Result
			Result.set_pebble (Result)
			Result.set_text ("Empty:  no VIEW")
		end

	state: SPLIT_MANAGER_STATE
			-- Create a structure representing the state of Current; to be used
			-- by `restore_state' during execution start.
		do
			save_split_positions
			create Result.make (Current)
		ensure
			result_exists: Result /= Void
		end

feature -- Element change

	set_root (a_root: like root)
			-- Change `root' and resync the manager.
		do
			Precursor {S_TREE} (a_root)
			syncronize
		end

--	restore_with_state (a_state: SPLIT_MANAGER_STATE) is
--			-- Restore Current to state as represented in `a_state'
--		require
--			state_exists: a_state /= Void
--		local
--			des: like descendents
--			ns: SPLIT_MANAGER_NODE_STATE
--		do
--			if a_state.is_mode_frozen then
--				disable_mode_changes
--			else
--				enable_mode_changes
--			end
--			if a_state.is_interface_frozen then
--				disable_interface_changes
--			else
--				enable_interface_changes
--			end
--			if a_state.is_single_mode then
--				set_single_mode
--			elseif a_state.is_split_mode then
--				set_split_mode
--			elseif a_state.is_notebook_mode then
--				set_notebook_mode
--			else
--				check
--					should_not_happen: False
--						-- because there are only three modes.
--				end
--			end
--				-- Restore each node's state
--			des := root.descendents
--			check
--				same_count: des.count = a_state.node_states.count
--					-- The saved node states should have the same form as the
--					-- node tree in the current window.
--			end
--			from
--				a_state.node_states.start
--				des.start
--			until a_state.node_states.exhausted or else des.exhausted
--			loop
--				ns := a_state.node_states.item
--				des.item.restore_with_state (ns)
--				a_state.node_states.forth
--				des.forth
--			end
--			syncronize
--		end

feature -- Basic operations

	extend (a_item: VIEW)
			-- Add `a_item' as a sibling to the previously added item.
		do
			Precursor {S_TREE} (a_item)
			if selected_node = Void then
				selected_node := corresponding_node (a_item)
			end
			add_agents (corresponding_node (a_item))
			syncronize
		end

	extend_siblings (a_first, a_second: VIEW)
			-- Searching from `root', find the nodes containing `a_first', and/or
			-- `a_second' or, if not finding them, create new nodes containing
			-- `a_first', and `a_second' and make them children of a new node.
			--  Make `root' reference the new node.
		local
			n: like root
			had_first, had_second: BOOLEAN
		do
				-- Prevent agents from being added twice if the tree already has the item.
			if has (a_first) then
				had_first := True
			end
			if has (a_second) then
				had_second := True
			end
			Precursor {S_TREE} (a_first, a_second)
			n := corresponding_node (a_first)
			if selected_node = Void then
				selected_node := n
			end
			if n.is_view and then not had_first then
				add_agents (n)
			end
			n := corresponding_node (a_second)
			if n.is_view and then not had_second then
				add_agents (n)
			end
			syncronize
		end

	wipe_out_views
			-- Clean out all the views in preperation for rebuilding.
		do
				-- Wipe out the containers
			notebook.wipe_out
				-- Wipe out the EV_CONTAINERs
			toggle_bar.wipe_out
			radio_bar.wipe_out
			toggle_menu.wipe_out
			radio_menu.wipe_out
				-- Reset the view to default state
			selected_node := root
--			build_bars
		end

	select_view (a_view: VIEW)
			-- Make `a_view' the `selected_view'
		require
			view_exists: a_view /= Void
			has_view: has_view (a_view)
		do
			check attached corresponding_node (a_view) as n then
				n.show
				selected_node := n
			end
			syncronize
		ensure
			view_was_selected: selected_view = a_view
		end

	toggle_view (a_view: VIEW)
			-- If `a_view' is hidden then show it; if it is shown hide it.
			-- The effect from this will show up in split mode.
		require
			view_exists: a_view /= Void
			has_view: has_view (a_view)
		local
			n: like root
		do
			n := corresponding_node (a_view)
			check
				is_view: n.is_view
					-- Because if `has_view' then `n' must be a view.
			end
			if n.is_hidden then
				n.show
				selected_node := n
			else
				if visible_count > 1 then
					save_split_positions
					n.hide
				end
			end
			syncronize
		end

	show_all_views
			-- Make all the views visible
		local
			s: like leaf_nodes
		do
			s := leaf_nodes
			from s.start
			until s.exhausted
			loop
				s.item.show
				s.forth
			end
			syncronize
		end

	show_view (a_view: VIEW)
			-- Make `a_view' visible
		require
			view_exists: a_view /= Void
			has_view: has_view (a_view)
		local
			n: like root
		do
			n := corresponding_node (a_view)
			if not n.is_visible then
				n.show
				restore_split_positions
			end
			select_view (a_view)
		ensure
			view_visible: corresponding_node (a_view).is_visible
			view_selected: selected_view = a_view
		end

	hide_view (a_view: VIEW)
			-- React to a request to hide `a_view'
		require
			view_exists: a_view /= Void
			has_view: has_view (a_view)
			is_in_split_mode: is_split_mode
		local
			n: like root
		do
			if visible_count > 1 then
				save_split_positions
				n := corresponding_node (a_view)
				n.hide
				if selected_view = a_view then
						-- Must select another
					select_view (first_visible_view)
				end
				syncronize
			end
		ensure
			view_not_visible: old visible_count > 1 implies not corresponding_node (a_view).is_visible
		end

	disable_view (a_view: VIEW)
			-- Prevent `a_view' from appearing and also remove the
			-- buttons and menus which will allow it to be shown.
			-- Use `enable_view' to restore it to normal.
		require
			view_exists: a_view /= Void
			has_view: has_view (a_view)
		do
			save_split_positions
			corresponding_node (a_view).disable
--			build_bars
--			build_cell
			syncronize
		ensure
			is_in_disabled_views: corresponding_node (a_view).is_disabled
		end

	enable_view (a_view: VIEW)
			-- Sets the view handling for `a_view' back to normal
			-- by restoring the corresponding buttons and menues.
		require
			view_exists: a_view /= Void
			has_view: has_view (a_view)
		do
			corresponding_node (a_view).enable
--			build_bars
--			build_cell
			restore_split_positions
			syncronize
		ensure
			view_not_disabled: not corresponding_node (a_view).is_disabled
		end

	set_single_mode_view (a_view: VIEW)
			-- Set to single mode with `a_view' visible, filling the `cell'.
		require
			view_exists: a_view /= Void
			has_view: has_view (a_view)
--			mode_is_changable: is_mode_changable
		do
			set_single_mode
			if selected_view /= a_view then
				select_view (a_view)
			end
		ensure
			is_single_mode: is_single_mode
			correct_view_selected: selected_view = a_view
		end

	set_split_mode_view (a_view: VIEW)
			-- Multiple views can be visible within `cell'.
			-- Ensure `a_view' is the selected view.
		require
			view_exists: a_view /= Void
			has_view: has_view (a_view)
--			mode_is_changable: is_mode_changable
		do
			set_split_mode
			if selected_view /= a_view then
				select_view (a_view)
			end
		ensure
			is_split_mode: is_split_mode
			correct_view_selected: selected_view = a_view
		end

	set_notebook_mode_view (a_view: VIEW)
			-- Change to notebook style with `a_view' on top.
		require
			view_exists: a_view /= Void
			has_view: has_view (a_view)
--			mode_is_changable: is_mode_changable
		do
			set_notebook_mode
			if selected_view /= a_view then
				select_view (a_view)
			end
		ensure
			is_notebook_mode: is_notebook_mode
			correct_view_selected: selected_view = a_view
		end

feature -- Status report

	is_interface_frozen: BOOLEAN
			-- Is the set of visible views frozen (i.e. can the user toggle a view
			-- on or off)?  (Assuming there is more than one view.)
			-- This affects the interface, not the programmers ability to change.

	is_mode_frozen: BOOLEAN
			-- Is the "mode" frozen (i.e. if `is_single_mode' always single mode)?
			-- This affects the interface, not the programmers ability to change.
			-- See `enable_mode_changes' and `disable_mode_changes'.

	is_single_mode: BOOLEAN
			-- Is only one view in `cell'?

	is_split_mode: BOOLEAN
			-- Is the view in split mode (multiple views showing)?

	is_notebook_mode: BOOLEAN
			-- Is the view in notebook mode (multiple views in an EV_NOTEBOOK)?

feature -- Status setting

	enable_mode_changes
			-- Allow the *user* (not to be confused with *programer*) to change
			-- the way the contained views (if there is more than one view) are
			-- presented in `cell' by setting `is_mode_frozen' to True.
			-- If more than one view is present and `is_interface_frozen' then
			-- buttons and menus for changing the mode will be made available to
			-- the programmer in `bar' and `menu' which can then be presented to
			-- the user.
		do
			is_mode_frozen := False
			if not is_empty and then view_count >= 2 then
				build_bars
			end
			build_cell
		ensure
			mode_is_changable: not is_mode_frozen
		end

	disable_mode_changes
			-- Prevent *user* changes to the "mode" by setting `is_mode_changable'
			-- to False.  The user will see what ever appearance has been set
			-- by the programmer using the `set_..._mode' features.
			-- See `set_split_mode', `set_single_mode',and `set_notebook_mode'.
		do
			is_mode_frozen := True
		ensure
			mode_is_not_changable: is_mode_frozen
		end

	enable_interface_changes
			-- Allow the *user* to toggle the visible views.
			-- Used to add the buttons and menues from `bar'.
		do
			is_interface_frozen := False
		ensure
			views_are_changable: not is_interface_frozen
		end

	disable_interface_changes
			-- Prevent the *user* from toggling the visible views.
			-- Used to hide or remove the buttons and menues from `bar'.
		do
			is_interface_frozen := True
		ensure
			views_not_changable: is_interface_frozen
		end

	set_single_mode
			-- Make the `cell' hold only one widget, either the `selected_view' or,
			-- if there are no views, a `default_view'.
--		require
--			mode_is_changable: is_mode_changable
		do
			if not is_single_mode then
				if is_split_mode then
					save_split_positions
				end
				is_single_mode := True
				is_split_mode := False
				is_notebook_mode := False
				syncronize
			end
--			select_view (selected_view)
		ensure
			is_single_mode: is_single_mode
		end

	set_split_mode
			-- Make the `cell' hold the views recursively in EV_SPLIT_AREAs.
			-- If there are no views then `cell' contains a `default_view'.
		require
			is_mode_changable: not is_mode_frozen
		local
			d: like descendents
		do
			if not is_split_mode then
				is_split_mode := True
				is_single_mode := False
				is_notebook_mode := False
				restore_split_positions
				syncronize
			end
			if not attached selected_view or else (
					attached selected_view as v and then not has (v)) then
				d := descendents
				if not d.is_empty then
					selected_node := descendents.first
				end
			end
			check attached selected_view as v then
				select_view (v)
			end
		ensure
			is_split_mode: is_split_mode
		end

	set_notebook_mode
			-- Make `cell' hold the views in an EV_NOTEBOOK.
			-- If there are no views then `cell' contains a `default_view'.
--		require
--			is_mode_changable: is_mode_changable
		do
			if not is_notebook_mode then
				if is_split_mode then
					save_split_positions
				end
				is_notebook_mode := True
				is_single_mode := False
				is_split_mode := False
				syncronize
			end
--			select_view (selected_view)
		ensure
			is_notebook_mode: is_notebook_mode
		end

feature -- Query

	is_visible (a_view: VIEW): BOOLEAN
			-- Is `a_view' visible?  (I.e. should it be added to `cell'?)
		do
			Result := has (a_view) and then corresponding_node (a_view).is_visible
		end

	is_disabled (a_view: VIEW): BOOLEAN
			-- Is `a_view' able to be shown?
		do
			Result := has (a_view) and then corresponding_node (a_view).is_disabled
		end

	has_split (a_split_area: EV_SPLIT_AREA): BOOLEAN
			-- Does Current contain/manage `a_split_area'?
		require
			split_exists: a_split_area /= Void
		local
			s: like internal_nodes
		do
			s := internal_nodes
			from s.start
			until Result or else s.exhausted
			loop
				Result := s.item.view = a_split_area
				s.forth
			end
		end

	has_view (a_view: VIEW): BOOLEAN
			-- Does Current contain/manage `a_view'?
		require
			view_exists: a_view /= Void
		local
			s: like leaf_nodes
		do
			s := leaf_nodes
			from s.start
			until Result or else s.exhausted
			loop
				Result := s.item.view = a_view
				s.forth
			end
		end

	is_conforming_type (a_view: ANY): BOOLEAN
			-- Does `a_view' conform to VIEW or EV_SPLIT_AREA?
			-- Would have preferred for `a_view' to be an EV_WIDGET but that caused
			-- too many name clashes in decendents of VIEW.
		require
			view_exists: a_view /= Void
		do
			Result := a_view.conforms_to ({VIEW}) or else a_view.conforms_to ({EV_SPLIT_AREA})
		ensure
			definition: Result implies a_view.conforms_to ({VIEW}) or else a_view.conforms_to ({EV_SPLIT_AREA})
		end

feature {SPLIT_MANAGER_STATE} -- Implementation (Query)

	root: detachable SPLIT_MANAGER_NODE
			-- Root node of the tree.

	selected_node: like root
			-- The node corresponding the the view last selected by the user.

feature {NONE} -- Implementation (Basic operations)

	add_agents (a_node: attached like root)
			-- Add agents to toggle/raise/minimize the widget
			-- (a VIEW) in `a_node'.
		require
			node_exists: a_node /= Void
			is_view: a_node.is_view
			has_view: has_node (a_node)
		do
			a_node.toggle_button.select_actions.extend (agent toggle_view (a_node.view))
			a_node.radio_button.select_actions.extend (agent select_view (a_node.view))
			a_node.toggle_item.select_actions.extend (agent toggle_view (a_node.view))
			a_node.radio_item.select_actions.extend (agent select_view (a_node.view))
				-- Add actions to the buttons of `a_view' if it is a TOOL
			if attached {TOOL} a_node.view as t then
					-- This item is a tool and therefore has buttons.
				t.maximize_actions.extend (agent set_single_mode_view (a_node.view))
				t.restore_actions.extend (agent set_split_mode_view (a_node.view))
				t.close_actions.extend (agent hide_view (a_node.view))
			end
		end

	save_split_positions
			-- Save the position of splitters for restoration later.
		local
			n: SPLIT_MANAGER_NODE
			s: like internal_nodes
		do
			s := internal_nodes
			from s.start
			until s.exhausted
			loop
				n := s.item
				check
					node_holds_split_area: n.is_split
						-- Because only EV_SPLIT_AREA widgets are added to the nodes in `splits'.
				end
				n.save_split_position
				s.forth
			end
		end

	restore_split_positions
			-- Set the split position of each visible split area to what it was
			-- when it was last visible.
		local
			n: SPLIT_MANAGER_NODE
			s: like internal_nodes
		do
			s := internal_nodes
			from s.start
			until s.exhausted
			loop
				n := s.item
				check
					node_holds_split_area: n.is_split
						-- Because only EV_SPLIT_AREA widgets are added to the nodes in `splits'.
				end
				n.restore_split_position
				s.forth
			end
		end

	syncronize
			-- Rebuild all the externally accessed widgets such as `cell', `menu',
			-- and `button_bar' reflect the state of the buttons.
			-- Also ensure that at least one view is visible if there are any views.
			-- and update button and menu states.
		do
			build_cell
			if visible_count >= 1 then
				syncronize_tools
					-- Make sure the radio items and buttons for the `selected_node' are set to
					-- the correct state.  This must be called after the radio buttons are added
					-- the the bar because the radio buttons for all the views must work together
					-- (when one selected the other turn off.)
				restore_split_positions
--				syncronize_view_selection_items
			end
			if view_count >= 2 then
				build_bars
				syncronize_mode_selection_items
				check attached selected_node as sn then
					sn.syncronize_buttons
				end
			end
		end

	syncronize_tools
			-- Make sure any TOOLs handled by the manager are in the correct
			-- state, either maximized or normal.
		local
			s: like leaf_nodes
		do
			s := leaf_nodes
			from s.start
			until s.exhausted
			loop
				if attached {TOOL} s.item.view as t then
					if s.count <= 1 then
						t.disable_resize
					else
						t.enable_resize
					end
					if is_single_mode then
						if t.is_resizable then
							t.maximize
						end
					else
						if t.is_resizable then
							t.restore
						end
					end
					if is_split_mode then
						t.close_button.enable_sensitive
						t.maximize_button.enable_sensitive
						t.restore_button.enable_sensitive
					else
						t.close_button.disable_sensitive
						t.maximize_button.disable_sensitive
--						t.restore_button.disable_sensitive
					end
				end
				s.forth
			end
		end

--	syncronize_view_selection_items is
--			-- Make sure the state of the radio and toggle reflect the value
--			-- of `selected_view' and visible views.
--		local
--			n: like root
--		do
--					-- Fix the radio items
--			
--			i := views.index_of (selected_view, 1)
--			rb := radio_buttons.i_th (i)
--			ri := radio_items.i_th (i)
--			ri.select_actions.block
--			ri.enable_select
--			ri.select_actions.resume
--			rb.select_actions.block
--			rb.enable_select
--			rb.select_actions.resume
--					-- Fix the toggle items
--			from views.start
--			until views.exhausted
--			loop
--				i := views.index
--				wv := views.item
--				if not disabled_views.has (wv) then
--					tb := toggle_buttons.i_th (i)
--					ti := toggle_items.i_th (i)
--					ti.select_actions.block
--					tb.select_actions.block
--					if visible_views.has (wv) then
--						ti.enable_select
--						tb.enable_select
--					else
--						ti.disable_select
--						tb.disable_select
--					end
--					ti.select_actions.resume
--					tb.select_actions.resume
--				end
--				views.forth
--			end
--		ensure
--			selected_view_unchanged: selected_view = old selected_view
--			toggle_items_agree: toggles_agree_with_visible_items
--			radio_items_agree: radios_agree_with_selected_view
--		end

	syncronize_mode_selection_items
			-- Set the button states
		require
			at_least_two_views: view_count >= 2
		do
			single_mode_button.select_actions.block
			split_mode_button.select_actions.block
			notebook_mode_button.select_actions.block
			single_mode_item.select_actions.block
			split_mode_item.select_actions.block
			notebook_mode_item.select_actions.block
			if is_split_mode then
				split_mode_button.enable_select
				split_mode_item.enable_select
			elseif is_notebook_mode then
				notebook_mode_button.enable_select
				notebook_mode_item.enable_select
			elseif is_single_mode then
				single_mode_button.enable_select
				single_mode_item.enable_select
			else
				check
					no_mode_should_not_happen: False
				end
			end
			single_mode_button.select_actions.resume
			split_mode_button.select_actions.resume
			notebook_mode_button.select_actions.resume
			single_mode_item.select_actions.resume
			split_mode_item.select_actions.resume
			notebook_mode_item.select_actions.resume
				-- for testing only
			if is_split_mode then
				check
--					one:   split_mode_button.is_selected
--					two:   split_mode_item.is_selected
--					three: not notebook_mode_button.is_selected
--					four:  not notebook_mode_item.is_selected
--					five:  not single_mode_button.is_selected
--					six:   not single_mode_item.is_selected
				end

			end
		ensure
--			split_mode_implication: is_split_mode implies
--				split_mode_button.is_selected and split_mode_item.is_selected and
--				not notebook_mode_button.is_selected and not notebook_mode_item.is_selected and
--				not single_mode_button.is_selected and not single_mode_item.is_selected
--			notebook_mode_implication: is_notebook_mode implies
--				notebook_mode_button.is_selected and notebook_mode_item.is_selected and
--				not single_mode_button.is_selected and not single_mode_item.is_selected and
--				not split_mode_button.is_selected and not split_mode_item.is_selected
--			single_mode_implication: is_single_mode implies
--				single_mode_button.is_selected and single_mode_item.is_selected and
--				not notebook_mode_button.is_selected and not notebook_mode_item.is_selected and
--				not split_mode_button.is_selected and not split_mode_item.is_selected
		end

	block_leaf_actions
			-- Removing and adding radio widgets to the `radio_bar' or `radio_menu' causes
			-- problems if the select actions fire, therefore block all those actions.
			-- The leaf nodes only should have any corresponding button for selections.
		local
			s: like leaf_nodes
		do
			s := leaf_nodes
			from s.start
			until s.exhausted
			loop
				s.item.block_radio_actions
				s.forth
			end
		end

	resume_leaf_actions
			-- Resume actions for leaf node widgets (see `block_leaf_actions')
		local
			s: like leaf_nodes
		do
			s := leaf_nodes
			from s.start
			until s.exhausted
			loop
				s.item.resume_radio_actions
				s.forth
			end
		end

	build_bars
			-- Put the correct buttons in the `bar' and the correct
			-- menu items into `menu'.  Make sure the button and menu
			-- states agree with the state of Current.
		require
			at_least_two_views: view_count >= 2
		local
			n: SPLIT_MANAGER_NODE
			s: like leaf_nodes
		do
--			toggle_bar.disable_sensitive
--			radio_bar.disable_sensitive
--			toggle_menu.disable_sensitive
--			radio_menu.disable_sensitive
				-- Build the `radio_bar', `toggle_bar', `toggle_menu', and `radio_menu'
				-- Calling `wipeout' on an EV_TOGGLE_BUTTON or EV_TOGGLE_ITEM caused one
				-- of the other buttons or items in the group to be selected.  This calls
				-- the select actions on that widget, one of which is to select a view.
				-- This will eventually lead to a call to `synchronize' and then back
				-- to this feature.  This is undesirable, so to prevent the callback,
				-- we must block the select actions for each of the radio widgets.
			block_leaf_actions
			toggle_bar.wipe_out
			radio_bar.wipe_out
			toggle_menu.wipe_out
			radio_menu.wipe_out
			s := leaf_nodes
			from s.start
			until s.exhausted
			loop
				n := s.item
				if not n.is_disabled then
					toggle_bar.extend (n.toggle_button)
					radio_bar.extend (n.radio_button)
					toggle_menu.extend (n.toggle_item)
--					radio_menu.extend (n.radio_item)
				end
				s.forth
			end
				-- Un-block the actions on any selectable widgets in the bar or menu
			from radio_bar.start
			until radio_bar.exhausted
			loop
				check attached {EV_TOOL_BAR_RADIO_BUTTON} radio_bar.item as b then
					b.select_actions.resume
				end
				radio_bar.forth
			end
			from radio_menu.start
			until radio_menu.exhausted
			loop
				check attached {EV_RADIO_MENU_ITEM} radio_menu.item as ri then
					ri.select_actions.resume
				end
				radio_menu.forth
			end
				--  Build the bar
			bar.wipe_out
			if leaf_nodes.count >= 2 then
				if not is_mode_frozen then
					bar.extend (mode_bar)
					bar.disable_item_expand (mode_bar)
				end
				if not is_interface_frozen then
					if is_single_mode or else is_notebook_mode then
						bar.extend (radio_bar)
						bar.disable_item_expand (radio_bar)
					elseif is_split_mode then
						bar.extend (toggle_bar)
						bar.disable_item_expand (toggle_bar)
					end
				end
			end
				-- Build the menu
			menu.wipe_out
			if not is_mode_frozen then
				menu.extend (mode_menu)
			end
			if not is_interface_frozen then
				if is_single_mode or else is_notebook_mode then
					menu.extend (radio_menu)
				elseif is_split_mode then
					menu.extend (toggle_menu)
				end
			end
			if visible_count >= 2 then
				toggle_bar.enable_sensitive
				mode_menu.enable_sensitive
				radio_menu.enable_sensitive
				toggle_menu.enable_sensitive
			else
				toggle_bar.disable_sensitive
				mode_menu.disable_sensitive
				radio_menu.disable_sensitive
				toggle_menu.disable_sensitive
			end
			resume_leaf_actions
		end

	build_cell
			-- Put the appropriate EV_SPLIT_AREA or VIEW into `cell' based on user
			-- button or menu selections.  This must be done whenever the list
			-- of visible_views changes or when a view is disabled.
		local
			s: like leaf_nodes
			n: detachable like root
			v: VIEW
--			b: EV_TOOL_BAR_RADIO_BUTTON
		do
				-- Must wipeout all the containers to prevent putting a view into
				-- more than one container at a time.
				-- This requires building the notebook here if `is_notebook_mode'
			cell.wipe_out
			if notebook /= Void then
				notebook.selection_actions.block
				notebook.wipe_out
			end
			wipeout_splits
			if view_count >= 1 then
				if is_single_mode or else view_count < 2 then
					check attached {EV_WIDGET} selected_view as ev_w then
							-- because all managed `views' should be EV_WIDGETS
						cell.extend (ev_w)
					end
				elseif is_notebook_mode then
					s := leaf_nodes
					from s.start
					until s.exhausted
					loop
						check
							s.item.is_view
								-- Because `views' should hold only nodes that contain a VIEW in `widget'.
							end
						n := s.item
						if not n.is_disabled then
							check attached {EV_WIDGET} n.view as ev_w then
									-- because all managed `views' should be EV_WIDGETS
								notebook.extend (ev_w)
								notebook.set_item_text (ev_w, ev_w.generating_type)
							end
						end
						s.forth
					end
					if n /= Void then
						check attached {EV_WIDGET} n.view as ev_w then
								-- because all managed `views' should be EV_WIDGETS
							notebook.select_item (ev_w)
						end
					end
					cell.extend (notebook)
					notebook.selection_actions.resume
				else
					check
						is_split_mode: is_split_mode
								-- because only mode left
					end
					if attached root as r then
						cell.extend (r.visible_widget)
					end
					restore_split_positions
				end
			end
		end

	wipeout_splits
			-- Clean out all the split areas.
		local
			s: like internal_nodes
		do
			s := internal_nodes
			from s.start
			until s.exhausted
			loop
				check
					is_split: s.item.is_split
						-- Because splits hold only nodes containing EV_SPLIT_AREA is `widget'.
				end
				s.item.split_area.wipe_out
				s.forth
			end
		end

feature {NONE} -- Implementation (Actions)

	on_mode_change
			-- The "mode" has changed, so rebuild the `bar' and `menu'
			-- and syncronize other items.
		do
			save_split_positions
			syncronize
		end

	on_tab_selected
			-- React to a request from the `notebook' to select `a_view'
		require
			is_notebook_mode: is_notebook_mode
		do
			check attached {VIEW} notebook.selected_item as v then
				select_view (v)
			end
		end

feature {NONE} -- Implementation

	has_invalid_leaf_type: BOOLEAN
			-- Used by invariant to make sure all leaf nodes contain VIEWs.
		local
			s: like leaf_nodes
			n: like root
		do
			s := leaf_nodes
			from s.start
			until Result or else s.exhausted
			loop
				n := s.item
				Result := not n.is_view
				if not n.is_view then
					Result := True
				end
				s.forth
			end
		end

	has_invalid_internal_type: BOOLEAN
			-- Used by invariant to make sure all internal nodes contain EV_SPLIT_AREAs.
		local
			s: like internal_nodes
			n: like root
		do
			s := internal_nodes
			from s.start
			until Result or else s.exhausted
			loop
				n := s.item
				Result := not n.is_split
				s.forth
			end
		end

feature {NONE} -- Implementation (tool bars and buttons)

	notebook: EV_NOTEBOOK
			-- Used internally to build `cell' when `notebook_mode_button' is selected.

	mode_bar: EV_TOOL_BAR
			-- Holds the view mode buttons ('build_mode_button', 'single_mode_button',
			-- `normal_mode_button', and `notebook_mode_button'.

	toggle_bar: EV_TOOL_BAR
			-- Holds buttons which toggle multiple views on and off.

	radio_bar: EV_TOOL_BAR
			-- Holds buttons used to select one of several views.

	single_mode_button: EV_TOOL_BAR_RADIO_BUTTON
			-- Used to put the views into a maximized state

	split_mode_button: EV_TOOL_BAR_RADIO_BUTTON
			-- Puts the manager into normal view mode (all selected views are visible).

	notebook_mode_button: EV_TOOL_BAR_RADIO_BUTTON
			-- Puts the manager into a mode in which the views are
			-- placed withing an EV_NOTEBOOK.

feature {NONE} -- Implementation (menus and items)

	mode_menu: EV_MENU
			-- Holds menu items for changing the mode

	toggle_menu: EV_MENU
			-- Holds menu items used when not `is_maximized' and not `is_builder_mode'
			-- to toggle views on and off or to `maximize' the views.

	radio_menu: EV_MENU
			-- Holds menu items used when `is_maximized' and not `is_builder_mode'
			-- to select one of several views or to `restore' the views.

	single_mode_item: EV_RADIO_MENU_ITEM
			-- Maximizes the `selected_view'

	split_mode_item: EV_RADIO_MENU_ITEM
			-- Reverts to `is_split_mode'

	notebook_mode_item: EV_RADIO_MENU_ITEM
			-- Changes to notebook mode

invariant

	cell_exists: cell /= Void
	not_has_invalid_leaf_type: not has_invalid_leaf_type
	not_has_invalid_internal_type: not has_invalid_internal_type

--	one_view_implies_root_exists: count >= 1 implies root /= Void
--	one_view_implies_selected_node_exists: count >= 1 implies selected_node /= Void
--	two_views_implies_exported_widgets_exist: count >= 2 implies (menu /= Void and bar /= Void)
--	two_views_implies_widgets_exist: count >= 2 implies
--		(notebook /= Void and mode_bar /= Void and toggle_bar /= Void and radio_bar /= Void and
--		single_mode_button /= Void and split_mode_button /= Void and notebook_mode_button /= Void and
--		mode_menu /= Void and toggle_menu /= Void and radio_menu /= Void and
--		single_mode_item /= Void and split_mode_item /= Void and notebook_mode_item /= Void)

end

