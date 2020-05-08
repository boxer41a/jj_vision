note
	description: "[
			A JJ_NODE_ITEM which can hold only a VIEWABLE_LEAF_NODE and placeable
			into a JJ_TREE_VIEW.
				]"
	author: "Jimmy J. Johnson"
	date: "$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision: "$Revision: 7 $"

class
	JJ_LEAF_NODE_ITEM

inherit

	JJ_NODE_ITEM
		redefine
			set_actions,
			target,
			on_drop_node
		end

create
	default_create

feature {NONE} -- Initialization

	set_actions
			-- Add actions to the widget, but...
			-- remove the actions which will accept a drop of a node, because
			-- we cannot add a child node to the `target'.
			-- This does not prevent adding other drop actions, even a drop of
			-- a node as long as it doesn't add a child node to `target'.
		do
			Precursor {JJ_NODE_ITEM}
				-- clear the drop actions.  This is safe at this time because
				-- JJ_NODE_ITEM only adds one drop action which is the one that
				-- must be removed anyway.
			drop_actions.wipe_out
		end

feature -- Access

	target: NODE
			-- The node which is displayed by Current.

feature -- Testing for now

	on_drop_node (a_node: NODE)
			-- Can this be done?
		do
			check
				do_not_call: False
			end
		end

end
