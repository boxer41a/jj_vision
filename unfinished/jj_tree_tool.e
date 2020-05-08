note
	description: "[
		TOOL used to hold a JJ_TREE_VIEW for displaying a hierarchical
		structure of VIEWABLE_NODEs.
		]"
	author: "Jimmy J. Johnson"
	date: "21 Apr 06"

class
	JJ_TREE_TOOL

inherit

	TOOL
		redefine
			initialize,
			initialize_interface,
			set_actions,
			target,
			set_target,
			set_button_states,
			draw
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
			-- Set up the window
		do
			create tree_view
				-- Create the new buttons before Precursor {TOOL} so `initialize'
				-- can call `set_actions' without a Void reference.
			create target_system_button
			create new_node_button
			create view_descendants_button
			create view_ancestors_button
			create cut_button
				-- "Register" the widgets with the `interface_table' in use by the
				-- current program (from SHARED in the "Standard Interface" cluster).
			interface_table.register_widget (target_system_button, "{JJ_TREE_TOOL} - target_system")
			interface_table.register_widget (new_node_button, "{JJ_TREE_TOOL} - new_node")
			interface_table.register_widget (view_descendants_button, "{JJ_TREE_TOOL} - view_descendants")
			interface_table.register_widget (view_ancestors_button, "{JJ_TREE_TOOL} - view_ancestors")
			interface_table.register_widget (cut_button, "{JJ_TREE_TOOL} - cut")
			interface_table.register_widget (Current, generating_type)
				-- Create the tool and its views
			Precursor {TOOL}
				-- Add the buttons to the `tool_bar' (from TOOL)
			tool_bar.extend (target_system_button)
			tool_bar.extend (new_node_button)
			tool_bar.extend (view_descendants_button)
			tool_bar.extend (view_ancestors_button)
			tool_bar.extend (cut_button)
				-- Set up the views in this tool.
--			view_manager.enable_mode_changes
			split_manager.extend (tree_view)
			set_actions_for_views
		end

	initialize_interface
			-- Create INTERFACE_ITEMs which could be used by Current.
			-- Called by `initialize'.
		do
				-- Only add an interface item for Current if its `interface_name' has
				-- not already been added; the other items are specific for this tool
				-- and most likely will not be redefine, so no need to check inclusion
				-- of these in the `interface_table'.
				-- In redefinitions of this feature call this at the end of the redefinition
				-- so an item for the `interface_name' can be added to the `interface_table'.
			if not interface_table.has_key (generating_type) then
				interface_table.add_item_with_tuple (<< generating_type, "JJ_TREE_TOOL", "Node tree tool", "Used to view relationships between nodes.", "icon_format_feature_descendants_color.ico">>)
			end
			interface_table.add_item_with_tuple (<<"{JJ_TREE_TOOL} - target_system", "Target System", "Make System be the target", "Set the target of this tool to the applications system.", "icon_object_symbol.ico">>)
			interface_table.add_item_with_tuple (<<"{JJ_TREE_TOOL} - new_node", "New Node", "Create a new node", "Create a new node.", "icon_cluster_symbol_color.ico">>)
			interface_table.add_item_with_tuple (<<"{JJ_TREE_TOOL} - view_descendants", "Descendents", "View descendants", "Show the descendent relationships of targeted object.", "icon_format_descendants_color.ico">>)
			interface_table.add_item_with_tuple (<<"{JJ_TREE_TOOL} - view_ancestors", "Ancestors", "View Ancestors", "Show the ancestor relationships of targeted object.", "icon_format_ancestors_color.ico">>)
			interface_table.add_item_with_tuple (<<"{JJ_TREE_TOOL} - cut", "Cut relationship", "Cut the link to the selected node", "Cut this link to the selected node.", "icon_cut_color.ico">>)
				-- Call Precursor after current is set up.  Specifically after the interface
				-- item for Current's `interface_name' is added.  (see above)
			Precursor {TOOL}
		end

	set_actions
			-- Add actions to the widgets
		do
			Precursor {TOOL}
			target_system_button.select_actions.extend (agent on_target_system_button_pressed)
			new_node_button.select_actions.extend (agent on_new_node_button_pressed (agent new_node))
			view_descendants_button.select_actions.extend (agent on_view_descendants_button_pressed)
			view_ancestors_button.select_actions.extend (agent on_view_ancestors_button_pressed)
			cut_button.select_actions.extend (agent on_cut_button_pressed)
		end

	set_actions_for_views
			-- Add actions to the views.  This can only be done after the views are
			-- created.  Because `set_actions' is called in the precursor to `initialize'
			-- this feature had to be added in order to access the "views" after they
			-- are created in `initialize' with the calls to `register_view_function'
			-- from `view_manager'.
		do
			tree_view.select_actions.extend (agent set_button_states)
		end

feature -- Access

	target: NODE
			-- The object handled by this tool.

	tree_view: JJ_TREE_VIEW
			-- The VIEW which actually does the displaying of
			-- the nodes in a tree.

feature -- Element change

	set_target (a_target: like target)
			-- Change the `target' of the tool.
			-- Redefined to propegate `a_target' to the `tree_view'.
		do
			Precursor {TOOL} (a_target)
			tree_view.set_target (a_target)
			draw
			set_button_states
		end

feature -- Basic operations

	draw
			-- Builds the string shown at top of the tool in `viewable_label'
			-- using the id of the object.
		local
			s: STRING
			n: NODE
			pw_test: ANY
		do
			Precursor {TOOL}
				-- Reminder:  `target_label' is built in Precursor {TOOL}; it fills in
				-- the `display_name' if the TOOL's target is an EDITALBE, else it uses
				-- the generating type of the target.
				-- So, this redefined version simply addes the "not in system text"
				-- to the display name if necessary.
			s := target_label.tooltip
			pw_test := parent_window.target
			n ?= parent_window.target
			check
				n /= Void
			end
			if n /= Void and then not n.descendants.has (target) then
				s := s + " " + interface_table.short_name ("not in system text")
			end
			target_label.set_tooltip (s)
			set_button_states
		end

	set_button_states
			-- Set the states of the buttons.
		local
			n: NODE
		do
			Precursor {TOOL}
			check
				tree_view_exists: tree_view /= Void
			end
			if tree_view.target = Void then
				new_node_button.disable_sensitive
				cut_button.disable_sensitive
				view_descendants_button.disable_sensitive
				view_ancestors_button.disable_sensitive
			else
				view_descendants_button.enable_sensitive
				view_ancestors_button.enable_sensitive
				n := tree_view.selected_target
				if n.can_adopt then
					new_node_button.enable_sensitive
				else
					new_node_button.disable_sensitive
				end
				if n /= target then
					cut_button.enable_sensitive
				else
					cut_button.disable_sensitive
				end
			end
		end

feature {NONE} -- Implementation (actions)

	on_target_system_button_pressed
			-- React to a press of the `target_system_button' by retargetting
			-- the view to the application's `target' and view descendents mode.
		local
			app: JJ_APPLICATION
			vn: NODE
		do
			app ?= (create {EV_ENVIRONMENT}).application
			check
				app_exists: app /= Void
					-- Because this class is only used by JJJ_APPLICATIONs
			end
			vn ?= app.target
			if vn /= Void then
				set_target (vn)
			end
			if tree_view.selected_item /= Void then
				tree_view.selected_item.disable_select
			end
			set_button_states
		end

	on_new_node_button_pressed (a_function: FUNCTION [JJ_TREE_TOOL, TUPLE, NODE])
			-- React to a press of the `new_node_button' by creating a
			-- new node using `a_function' and make the new node a child
			-- under the currently selected node.
		local
			c: ADD_NODE_COMMAND
			ti: EV_TREE_NODE
			new_n, n: NODE
		do
			new_n := a_function.item ([])
			create c
			n := tree_view.selected_target
			c.set_parent_node (n)
			c.set_child_node (new_n)
			command_manager.add_command (c)
				-- restore the selected object after a draw
			ti := tree_view.retrieve_item_recursively_by_data (n, False)
			if ti /= Void then
				ti.enable_select
			end
		end

	new_node: EDITABLE_NODE
			-- Creation feature for a new node, used in `on_new_node_button_pressed'.
		do
			create Result
		ensure
			result_exists: Result /= Void
		end

	on_view_ancestors_button_pressed
			-- React to a press of the `view_ancestors_button' by changing
			-- the `view' to ancestors mode.
		do
			tree_view.set_view_ancestors
		end

	on_view_descendants_button_pressed
			-- React to a press of the `view_descendants_button' by changing
			-- the `view' to descendants mode.
		do
			tree_view.set_view_descendants
		end

	on_cut_button_pressed
			-- React to a press of the `cut_button' by removing the current node
			-- from its parent.  (Does not necessarily delete from the system, but
			-- the node could be deleted if this is its only location in the tree.)
		require
			not_viewing_ancestors: not tree_view.is_viewing_ancestors
			cannot_cut_target_from_its_parent: tree_view.selected_target /= target
		local
			nti: JJ_NODE_ITEM
			nti_parent: JJ_NODE_ITEM
			parent_n: NODE
			n: NODE
			c: CUT_NODE_COMMAND
		do
			n := tree_view.selected_target
			nti := tree_view.selected_item
			nti_parent ?= nti.parent
			if nti_parent = Void then
				parent_n := target
				check
					parent_n.children.has (n)
						-- because otherwise we have the wrong parent
				end
			else
				parent_n := nti_parent.target
			end
			create c
			c.set_parent_node (parent_n)
			c.set_child_node (n)
			command_manager.add_command (c)
				-- Set the selected item to the `target' because we just deleted
				-- the selected item.
			draw_views (target)
		end

feature {NONE} -- Implementation (Buttons)

	target_system_button: EV_TOOL_BAR_BUTTON
			-- To restore the application's `system' as the target of the view.

	new_node_button: EV_TOOL_BAR_BUTTON
			-- To create a new DATABASE_RECORD.

	view_descendants_button: EV_TOOL_BAR_BUTTON
			-- To make the tree show descendants (recursively) of the `target'.

	view_ancestors_button: EV_TOOL_BAR_BUTTON
			-- To make the tree show descendants (recursively) of the `target'.

	cut_button: EV_TOOL_BAR_BUTTON
			-- To cut the link between a parent node and the currently selected node

end

