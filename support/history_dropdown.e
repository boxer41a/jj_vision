note
	description: "[
		Used to create the drop-down lists for the history
		buttons in a {TOOL}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/history_dropdown.e $"
	date:		"$Date: 2014-05-31 08:53:58 -0400 (Sat, 31 May 2014) $"
	revision:	"$Revision: 17 $"

class
	HISTORY_DROPDOWN

inherit

	ANY
		undefine
			default_create,
			copy
		end

	EV_DIALOG
--	EV_TITLED_WINDOW
		rename
			item as ev_dialog_item,
			extend as ev_dialog_extend,
			prune as ev_dialog_prune,
			count as ev_dialog_count,
			is_empty as ev_dialog_is_empty
--			start as ev_dialog_start,
--			forth as ev_dialog_forth,
--			exhausted as ev_dialog_exhausted
		export
			{NONE}
				all
			{ANY}
				is_destroyed
		redefine
			create_interface_objects,
			initialize,
			show
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {EV_DIALOG}
			create select_actions
			create list
		end

	initialize
			-- Set up current
		do
			Precursor {EV_DIALOG}
			ev_dialog_extend (list)
			set_actions
		end

	set_actions
			--
		do
			list.select_actions.extend (agent on_item_selected)
			list.focus_out_actions.extend (agent hide)
			focus_out_actions.extend (agent hide)
		end

feature -- Access

	parent_tool: TOOL
			-- Tool to use for placement of the dialog.
		require
			has_parent: has_parent_tool
		do
			check attached parent_tool_imp as t then
				Result := t
			end
		end

	item: HISTORY_ITEM
			-- The current item in the `list'
		require
			not_empty: not is_empty
		do
			check attached {like item} list.item as hi then
				Result := hi
			end
		ensure
			result_exists: Result /= Void
		end

	first: like item
			-- The first item in the `list'
		require
			not_empty: not is_empty
		do
			check attached {like item} list.first as hi then
				Result := hi
			end
		ensure
			result_exists: Result /= Void
		end

	selected_item: like item
			-- Item selected by the user from
		do
			check attached {like item} list.selected_item as hi then
				Result := hi
			end
		end

	count: INTEGER
			-- The number of items in the `list'
		do
			Result := list.count
		ensure
			definition: Result = list.count
		end

	select_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when an item is selected.

feature -- Element change

	extend (a_item: like selected_item)
			-- Add `a_item' to the `list'
		require
			item_exists: a_item /= Void
		do
			list.extend (a_item)
		ensure
			item_added: list.has (a_item)
		end

	prune (a_item: like item)
			-- Remove `a_item' from the `list'.
		do
			list.prune (a_item)
		ensure
			item_removed: not list.has (a_item)
		end

	set_parent_tool (a_tool: TOOL)
			-- Change `parent_tool'
		require
			tool_exists: a_tool /= Void
		do
			parent_tool_imp := a_tool
		ensure
			tool_assigned: parent_tool = a_tool
		end

feature -- Basic operations

	show
			-- Request that `Current' be displayed when its parent is.
			-- Build the list
		do
--			if not list.off then
--				list.item.enable_select
--			end
			set_position (parent_tool.target_label.screen_x, parent_tool.target_label.screen_y)
			set_width (150)
			set_height (150)
--			if not parent_tool.is_view_off then
--				set_title (parent_tool.target.id)
--			end
			Precursor {EV_DIALOG}
--			Precursor {EV_TITLED_WINDOW}
		end

feature -- Cursor movement

	start
			-- Go to first item in the `list'.
		do
			list.start
		end

	forth
			-- Go to next item in the `list'
		require
			not_after: not is_after
		do
			list.forth
		end

	back
			-- Move the `list' cursor back one item.
		require
			not_before: not is_before
		do
			list.back
		end

	search (a_item: like item)
			-- Move to first position (at or after current
			-- position) where `item' and `v' are equal.
			-- If structure does not include `v' ensure that
			-- `exhausted' will be true.
			-- This uses reference equality checks
		do
			list.search (a_item)
		end

feature -- Query

	has_parent_tool: BOOLEAN
			-- Does current have a parent of type {TOOL}?
		do
			Result := attached parent_tool
		end

	has_similar_items (a_time_stamped_viewable: like item): BOOLEAN
			-- Does current contain a_viewable with
		do
			from start
			until is_exhausted or Result
			loop
				Result := item.is_simular (a_time_stamped_viewable)
				forth
			end
		end

feature -- Status report

	is_exhausted: BOOLEAN
			-- Is the `list' exhausted?
		do
			Result := list.exhausted
		ensure
			definition: Result = list.exhausted
		end

	is_off: BOOLEAN
			-- Is the `list' cursor past the end or before the first item?
		do
			Result := list.off
		ensure
			definition: Result = list.off
		end

	is_empty: BOOLEAN
			-- Is the `list' empty?
		do
			Result := list.is_empty
		ensure
			definition: Result = list.is_empty
		end

	is_first: BOOLEAN
			-- Is the `list' cursor on the first item?
		do
			Result := list.isfirst
		ensure
			definition: Result = list.isfirst
		end

	is_last: BOOLEAN
			-- Is the `list' cursor on the last item?
		do
			Result := list.islast
		ensure
			definition: Result = list.islast
		end

	is_before: BOOLEAN
			-- Is the `list' cursor before the first item?
		do
			Result := list.before
		ensure
			definition: Result = list.before
		end

	is_after: BOOLEAN
			-- Is the `list' cursor after the last item?
		do
			Result := list.after
		ensure
			definition: Result = list.after
		end

feature -- Actions

	on_item_selected
			-- React to a list item selection
		do
			select_actions.call ([list.selected_item])
		end

feature {NONE} -- Implementation

	list: HISTORY_LIST
			-- EV_LIST descendant which holds HISTORY_ITEMs

	parent_tool_imp: detachable like parent_tool
			-- Detachable implementation of `parent_tool' for void-safe Eiffel

invariant

	list_exists: list /= Void
	select_actions_exists: select_actions /= Void

end
