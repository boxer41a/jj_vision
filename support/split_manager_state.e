note
	description: "[
		Used to make a STORABLE object for saving and restoring the
		state of a {SPLIT_MANAGER}
		]"
	date: "10 Sep 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/split_manager_state.e $"
	date:		"$Date: 2012-03-16 17:06:23 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 8 $"

class
	SPLIT_MANAGER_STATE

inherit

	STATE
		redefine
			make,
			set_view_attributes
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	make (a_split_manager: SPLIT_MANAGER)
			-- Initialize from attributes of `a_split_manager'.
		do
			Precursor {STATE} (a_split_manager)
			is_mode_frozen := a_split_manager.is_mode_frozen
			is_interface_frozen := a_split_manager.is_interface_frozen
			is_single_mode := a_split_manager.is_single_mode
			is_split_mode := a_split_manager.is_split_mode
			is_notebook_mode := a_split_manager.is_notebook_mode
			if attached a_split_manager.root as r then
				root_state := r.state
			end
		end

feature -- Access

	set_view_attributes
			-- The manager initialized from the attributes of Current.
		do
			if attached root_state as rs then
				view.set_root (rs.view)
			end
			if is_mode_frozen then
				view.disable_mode_changes
			else
				view.enable_mode_changes
			end
			if is_interface_frozen then
				view.disable_interface_changes
			else
				view.enable_interface_changes
			end
			if is_single_mode then
				view.set_single_mode
			elseif is_split_mode then
				view.set_split_mode
			elseif is_notebook_mode then
				view.set_notebook_mode
			else
				check
					should_not_happen: False
						-- because there are only three modes.
				end
			end
		end

feature {SPLIT_MANAGER} -- Implementation

	root_state: detachable SPLIT_MANAGER_NODE_STATE
			-- Representation of the top (binary) node in the tree.

	is_mode_frozen: BOOLEAN
			-- Corresponds to `is_mode_frozen' in SPLIT_MANAGER.

	is_interface_frozen: BOOLEAN
			-- Corresponds to `is_veiw_frozen' in SPLIT_MANAGER.

	is_single_mode: BOOLEAN
			-- Corresponds to `is_single_mode' in SPLIT_MANAGER.

	is_split_mode: BOOLEAN
			-- Corresponds to `is_split_mode' in SPLIT_MANAGER.

	is_notebook_mode: BOOLEAN
			-- Corresponds to `is_notebook_mode' in SPLIT_MANAGER.

	selected_view: INTEGER
			-- Corresponds to `selected_view' in VIEW_MANAGER but hold an
			-- integer index to reference the correct view in `views'.

feature {NONE} -- Implementation

	new_view: SPLIT_MANAGER
			-- Create the `view_imp'
		do
			create Result
		end

invariant

end
