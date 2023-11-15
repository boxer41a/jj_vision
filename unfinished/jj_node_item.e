note
	description: "[
				Objects placeable into an EV_TREE, more specifically into a
				JJ_TREE_VIEW (a VIEW that holds VIEWABLE_NODEs).  This is the
				screen representatin of a VIEWABLE_NODE.
				]"
	author: "Jimmy J. Johnson"
	date: "21 Apr 06"

class
	JJ_NODE_ITEM

inherit

--	EV_STOCK_COLORS
--		rename
--			implementation as colors_implementation
--		export
--			{NONE} all
--		undefine
--			default_create,
--			copy,
--			is_equal
--		end

	EV_TREE_ITEM
		redefine
			initialize,
			item,
			parent_tree,	-- to get correct type
			wipe_out,
			destroy,
			is_destroyed
		end

	VIEW
		rename
			parent as parent_from_view_not_to_be_used
		undefine
--			default_create,
			is_equal,
			copy
		redefine
			initialize,
			target,
			set_target,
			draw,
			parent_tool,
			destroy,
			is_destroyed
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
			-- Create an instance.
		do
			Precursor {VIEW}
			Precursor {EV_TREE_ITEM}
--			enable_pebble_positioning
--			set_pebble_position (0, 0)
			set_actions
		end

	set_actions
			-- Add actions to the widget
		do
			pick_actions.force_extend (agent enable_select)
			drop_actions.extend (agent on_drop_node)
			pointer_double_press_actions.force_extend (agent on_double_click)
		end

feature -- Access

	target: NODE
			-- The node which is displayed by Current.

	level: INTEGER
			-- The indention level this node should occupy in the tree.

	item: JJ_NODE_ITEM
			-- Current item.
			-- Redefined to change the type
		do
			Result ?= Precursor {EV_TREE_ITEM}
		end

	parent_tree: JJ_TREE_VIEW
			-- Contains Current
			-- Redefined to change type.
		do
			Result ?= Precursor {EV_TREE_ITEM}
		end

	parent_tool: JJ_TREE_TOOL
			-- The TOOL which contains this view.
			-- Can not be Void.
		do
			Result := parent_tree.parent_tool
		ensure then
			result_exists: Result /= Void
		end

feature -- Element change

	wipe_out
			-- Clean out the view
		do
			recursive_do_all (agent clear_viewables)
--			remove_all_viewables
			Precursor {EV_TREE_ITEM}
		end

	clear_viewables (a_node: EV_TREE_NODE)
			--
		local
			ti: JJ_NODE_ITEM
		do
			ti ?= a_node
			if ti /= Void then
				ti.remove_all_targets
			end
		end

	set_target (a_target: like target)
			-- Change `target'
		do
			Precursor {VIEW} (a_target)
			set_pebble (a_target)
			set_data (a_target)
			set_accept_cursor (yes_cursor (a_target))
			set_deny_cursor (no_cursor (a_target))
--			if a_object.can_adopt then
--				drop_actions.append (a_object.adopt_actions)
--			end
			draw
		end

	set_level (a_level: INTEGER)
			-- Change `level'
		do
			level := a_level
		ensure
			level_was_set: level = a_level
		end

feature -- Status

	is_viewing_ancestors: BOOLEAN
			-- Are the nodes in the tree sorted by anscestors?

	is_destroyed: BOOLEAN
			-- Is `Current' no longer usable?
		do
			Result := Precursor {VIEW} and Precursor {EV_TREE_ITEM}
		end

feature -- Status setting

	destroy
			-- Destroy underlying native toolkit object.
			-- Render `Current' unusable.
		do
			Precursor {VIEW}
			Precursor {EV_TREE_ITEM}
		end

	view_ancestors
			-- Make the view display ancestor nodes
		do
			is_viewing_ancestors := True
		end

	view_descendants
			-- Make the view dispay descendant nodes
		do
			is_viewing_ancestors := False
		end

feature -- Querry

	has_object_item (a_target: NODE): BOOLEAN
			-- Does Current contain an item with `target' equal to `a_target'?
		require
			target_exists: a_target /= Void
		do
			from start
			until Result or else exhausted
			loop
				Result := item.target = a_target
				forth
			end
		end

feature -- Basic operations

	draw
			-- Add children of `a_item.data' to the tree
		local
			n: NODE
			n_list: LINEAR [NODE]
			ti: JJ_NODE_ITEM
			pix: EV_PIXMAP
			p_view: JJ_TREE_VIEW
			p_tool: TOOL
			p_win: JJ_MAIN_WINDOW
		do
			if parent_tree /= Void then
				p_view := parent_tree
				p_tool := p_view.parent_tool
				p_win ?= p_tool.parent_window
--				p_win ?= parent_window
				if p_view /= Void and then p_win /= Void then	--p_view.is_displayed and p_win /= Void then
						-- This check seems to be needed to keep the view from being drawn
						-- even when it is not shown.  Evidently draw gets called even if
						-- the TREE in which Current resides is not in any JJ_MAIN_WINDOW.
						-- (`parent_window' relies on a recursive search for Current in
						-- any descendents.  If no main_window has the tree in which Current
						-- resides then `parent_window' is Void
					n ?= p_win.target
					check
						n_exists: n /= Void
							-- because the parent must be a NODE_TREE_VIEW and the
							-- `target' of it must be a NODE
					end
					if target /= Void then
						if n.descendants.has (target) then
							set_text (display_name (target))
						else
							set_text (display_name (target) + " " + interface_table.short_name ("not in system text"))
						end
						pix := (interface_table.pixmap (display_name (target))).twin
-- FIX ME!!   Changing the pixmap in order to put a not simble over it if
-- not in system seems to be causing problems.  Specificly, it violates post-
-- condition of `set_pixmap'.  Work on this later, or do my own tree.
--					pix.set_background_color (Red)
--					pix.set_size (100, 300)
----					pix.fill_rectangle (pix.x_position + 5, pix.y_position, 100, 20)
----					pix.fill_rectangle (5, 0, 100, 20)
--					pix.set_line_width (3)
--					pix.draw_segment (0,0, pix.width, pix.height)
						remove_pixmap
						set_pixmap (pix)
----					pixmap.set_background_color (Red)
----					pixmap.set_size (100, pixmap.height)
----					pixmap.set_size (100, 100)
----					pixmap.fill_rectangle (pixmap.x_position + 5, pixmap.y_position, 100, 20)
----					pixmap.fill_rectangle (5, 0, 100, 20)
----					wipe_out
						if parent_tree.is_viewing_ancestors then
							n_list := target.parents
						else
							n_list := target.children
						end
							-- clean out items which should no longer be here
					end
					from start
					until exhausted
					loop
						if not n_list.has (item.target) then
							item.wipe_out	-- to remove all the views
							remove
						else
							forth
						end
					end
							-- Add new items
					from n_list.start
					until n_list.exhausted
					loop
						n := n_list.item
--						n_list.forth
						if not has_object_item (n) then	-- prevents duplicates
							ti := parent_tree.new_tree_item (n)
							extend (ti)
							ti.set_target (n)
						end
						n_list.forth
					end
				end
			end
		end

feature {NONE} -- Actions

	on_drop_node (a_node: NODE)
			-- React to a drop of `a_node' by adding `a_node' as child to
			-- the `target'?
		local
			c: ADD_NODE_COMMAND
		do
			create c
			c.set_parent_node (target)
			c.set_child_node (a_node)
			command_manager.add_command (c)
		end

	on_double_click
			-- React to a mouse double click by opening a NAMER_VIEW.
--		local
--			nv: NAMER_VIEW
		do
--			create nv
--			nv.set_target (target)
--			nv.set_position (50,50)
		end

feature {NONE} -- Inaplicable

	parent_from_view_not_to_be_used: EV_CONTAINER
			-- Redefined to effect it (was deferred from VIEW); it
			-- does no good in this class as the parent of a EV_TREE_ITEM
			-- does not conform to the parent of most VIEWs which should
			-- be EV_CONTAINERs.
		do
		end

end
