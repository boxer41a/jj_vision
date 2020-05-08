note
	description: "[
		Saves the state of a {SPLIT_MANGER_NODE}
		]"
	date: "17 Jan 08"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/split_manager_node_state.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	SPLIT_MANAGER_NODE_STATE

inherit

	STATE
		redefine
			make,
			set_view_attributes
		end

create
	make

feature {NONE} -- Initialization

	make (a_node: SPLIT_MANAGER_NODE)
			-- Create from the argument
		do
			is_disabled := a_node.is_disabled
			is_selected := a_node.is_selected
			is_hidden := a_node.is_hidden
			split_position := a_node.split_position
			if a_node.is_split then
				if attached {EV_VERTICAL_SPLIT_AREA} a_node.split_area then
					is_vertical := True
					first_node_state := a_node.first.state
					second_node_state := a_node.second.state
				end
			else
				is_split := False
				view_state := a_node.view.state
			end
		end

feature -- Access

	set_view_attributes
			-- The `view' initialized from attributes of Current.
		local
			sa: VIEW
		do
			if attached view_state as vs then
				view.set_view (vs.view)
			else
				if is_vertical then
					create {VERTICAL_SPLIT_VIEW} sa
				else
					create {HORIZONTAL_SPLIT_VIEW} sa
				end
				view.set_view (sa)
					-- Recusive call...[sort of]
				check attached first_node_state as f and attached second_node_state as s then
					view.set_children (f.view, s.view)
					view.set_split_position (split_position)
				end
			end
			if is_disabled then
				view.disable
			else
				view.enable
			end
			if is_hidden then
				view.hide
			else
				view.show
			end
		end

feature {NONE} -- Implementation

	view_state: detachable VIEW_STATE
			-- The state of the `view' in a SPLIT_MANAGER_NODE

	first_node_state: detachable SPLIT_MANAGER_NODE_STATE
			-- The state of the node's `first' child

	second_node_state: detachable SPLIT_MANAGER_NODE_STATE
			-- The state of the node's `second' child

	is_disabled: BOOLEAN
			-- Corresponds to `is_disabled' in SPLIT_MANAGER_NODE

	is_selected: BOOLEAN
			-- Corresponds to `is_selected' in SPLIT_MANAGER_NODE

	is_hidden: BOOLEAN
			-- Corresponds to `is_hidden' in SPLIT_MANAGER_NODE

	split_position: INTEGER_32
			-- Corresponds to `split_position' in SPLIT_MANAGER_NODE

	is_split: BOOLEAN
			-- Records that a node contains a {SPLIT_VIEW}

	is_vertical: BOOLEAN
			-- Did the node contain an VERTICAL_SPLIT_VIEW?

feature {NONE} -- Implementation

	new_view: SPLIT_MANAGER_NODE
			-- Create the `view_imp'
		do
			create Result
		end

invariant


end

