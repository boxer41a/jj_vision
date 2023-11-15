note
	description: "[
				Hierachical screen representation of VIEWABLE_NODEs.
				]"
	author: "Jimmy J. Johnson"
	date: "21 Apr 06"

class
	JJ_TREE_VIEW

inherit

	EV_TREE
		redefine
			initialize,
			item,
			selected_item,
			destroy,
			is_destroyed
		end

	VIEW
		undefine
--			default_create,
			copy,
			is_equal
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
			-- Set up the object
		do
			create item_list.make
			Precursor {VIEW}
			Precursor {EV_TREE}
				-- The tree is really just a root node, therefore there is only
				-- one `target' in this VIEW, and the sub-nodes are themselves VIEWs
				-- containing its own object.
			set_actions
		end

	set_actions
			-- Add actions to the widgets.
		do
			drop_actions.extend (agent on_drop_target)
		end

feature -- Access

	target: NODE
			-- The object this view will display.

	selected_item: JJ_NODE_ITEM
			-- Currently selected item at any level within tree hierarchy.
		do
			Result ?= Precursor {EV_TREE}
		end

	selected_target: like target
			-- The object (data) in the `selected_item'
		require
			target_exists: target /= Void
		do
			if selected_item /= Void then
				Result := selected_item.target
			else
				Result := target
			end
		ensure
			result_exists: Result /= Void
			no_item_selected_result: selected_item = Void implies Result = target
		end

	item: JJ_NODE_ITEM
			-- Current item (node) in the tree.
		do
			Result ?= Precursor {EV_TREE}
		end

	parent_tool: JJ_TREE_TOOL
			-- The JJ_TREE_TOOL which contains this view.
			-- Can not be Void.
		do
			Result ?= Precursor {VIEW}
		ensure then
			result_exists: Result /= Void
		end

feature -- Element change

	set_target (a_target: like target)
			-- Change the value of `target'.
		do
			Precursor {VIEW} (a_target)
			draw
		end

feature -- Status report

	is_viewing_ancestors: BOOLEAN
			-- Are the clusters in the tree sorted by anscestors?

	is_destroyed: BOOLEAN
			-- Is `Current' no longer usable?
		do
			Result := Precursor {VIEW} and Precursor {EV_TREE}
		end

feature -- Status setting

	set_view_descendants
			-- Change to an descendants view
		do
			is_viewing_ancestors := False
			if not is_draw_disabled then
				draw
			end
		end

	set_view_ancestors
			-- Change to an anscestors view
		do
			is_viewing_ancestors := True
			if not is_draw_disabled then
				draw
			end
		end

feature -- Basic operations

	destroy
			-- Destroy underlying native toolkit object.
			-- Render `Current' unusable.
		do
			Precursor {VIEW}
			Precursor {EV_TREE}
		end

	draw
			-- Build the view
		local
			t: like target
			tn: EV_TREE_NODE
			n_list: BILINEAR [NODE]
		do
				-- Get the selected object
			t := selected_target
				-- Clean out the tree
			from start
			until exhausted
			loop
				remove
			end
				-- Rebuild the tree recursively
			if target /= Void then
				if is_viewing_ancestors then
					n_list := target.parents
				else
					n_list := target.children
				end
				from n_list.start
				until n_list.exhausted
				loop
						-- Pass the type to `next_tree_item' to get the correct
						-- type of tree_item.
					root_item := new_tree_item (n_list.item)
					extend (root_item)
						-- But must also call `set_target' on that tree_item
						-- to force a draw (recursively).
					root_item.set_target (n_list.item)
--					expand_clusters
					if root_item.is_expandable then
						root_item.expand
					end
					n_list.forth
				end
			end
			if t /= Void then
				tn := retrieve_item_recursively_by_data (t, False)
				if tn /= Void then
					tn.enable_select
				end
			end
		end

feature {NONE} -- Implementation (actions)

	on_drop_target (a_target: like target)
			-- React to a drop of `a_target'.
		require
			target_exists: a_target /= Void
		do
			parent_tool.set_target (a_target)
		end

feature {NONE} -- Implementation

	root_item: JJ_NODE_ITEM
			-- Top-most item in the tree.
			-- Reminder: this is a EV_WIDGET which holds the data; not the data.

	item_list: LINKED_LIST [JJ_NODE_ITEM]
			-- List of items which are in the view
			-- Reminder: these items are EV_WIDGETs which holds the data; not the data.

feature {JJ_NODE_ITEM} -- Implementation

	new_tree_item (a_node: NODE): JJ_NODE_ITEM
			-- Create a new JJ_NODE_ITEM.
			-- `target' to `a_node'.
		require
			node_exists: a_node /= Void
		do
			if a_node.can_adopt then
				Result := create {JJ_NODE_ITEM}
			else
				Result := create {JJ_LEAF_NODE_ITEM}
			end
			Result.set_target (a_node)
		ensure
			result_exists: Result /= Void
		end

end
