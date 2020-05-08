note
	description: "[
		Structure to hold info about splits and views in {SPLIT_MANAGER}
		]"
	date: "12 Nov 07"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/split_manager_node.e $"
	date:		"$Date: 2012-05-31 14:05:35 -0400 (Thu, 31 May 2012) $"
	revision:	"$Revision: 10 $"

class
	SPLIT_MANAGER_NODE

inherit

	SHARED
		undefine
			default_create
		end

	S_TREE_NODE
		redefine
			default_create,
			make,
			test_print
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	default_create
			-- Create an instance containing an EV_VERTICAL_SPLIT_AREA
		do
				-- Just to preserve the invariant.
			create {VERTICAL_SPLIT_VIEW} view
			create toggle_button
			create radio_button
			create toggle_item
			create radio_item
		end

	make (a_view: like view)
			-- Initialize Current making `view' be `a_view'
		local
			s: STRING_32
		do
			view := a_view
			create toggle_button
			create radio_button
			create toggle_item
			create radio_item
-- Fix me!!
				-- Add tooltips/help/pixmaps to the buttons
			toggle_button.set_tooltip ("Toggle " + a_view.generating_type.out)
			toggle_button.set_pixmap (a_view.pixmap)
			toggle_item.set_text (a_view.generating_type.out)
			if is_view then
				enable
				show
			end
		end

feature -- Access

	visible_widget: EV_WIDGET
			-- The view or split area to be shown.
		require
			is_visible: is_branch_visible
		local
			w1, w2: detachable EV_WIDGET
			split_a: EV_SPLIT_AREA
			l_result: detachable EV_WIDGET
		do
			if is_split then
				if first.is_branch_visible then
					w1 := first.visible_widget
						-- Make sure the widget doesn't have a parent.
					if attached {EV_SPLIT_AREA} w1.parent as sa then
						sa.prune (w1)
					end
				end
--				if second /= Void and then second.is_branch_visible then
				if second.is_branch_visible then
					w2 := second.visible_widget
						-- Make sure the widget doesn't have a parent.
					if attached {EV_SPLIT_AREA} w2.parent as sa then
						sa.prune (w2)
					end
				end
				if w1 /= Void and w2 /= Void then
					check
						is_visible: is_visible
								-- Because both branches are visible (see `is_visible')
					end
					split_a := split_area
					split_a.set_first (w1)
					split_a.set_second (w2)
					l_result := split_a
				elseif w1 /= Void then
					l_result := w1
				else
					l_result := w2
				end
			else
				check
					is_visible: is_visible
						-- Becuase of precondition and this is a leaf node on the branch.
				end
				check attached {EV_WIDGET} view as w then
						-- Because VIEWs should be EV_WIDGET.
					l_result := w
				end
			end
			check attached l_result as r then
				Result := l_result
			end
		ensure
			result_exists: Result /= Void
		end

	split_area: EV_SPLIT_AREA
			-- The `view' typecast as a {EV_SPLIT_AREA}
		require
			is_split: is_split
		do
			check attached {EV_SPLIT_AREA} view as sa then
				Result := sa
			end
		ensure
			result_exists: Result /= Void
		end

	split_position: INTEGER
			-- The last position of the splitter if this is a split area.

	toggle_button: EV_TOOL_BAR_TOGGLE_BUTTON
			-- Button to toggle this view on and off.

	radio_button: EV_TOOL_BAR_RADIO_BUTTON
			-- Button to select this view.

	toggle_item: EV_CHECK_MENU_ITEM
			-- Menu item for toggling this view on and off.

	radio_item: EV_RADIO_MENU_ITEM
			-- Menu item for selecting this view.

	state: SPLIT_MANAGER_NODE_STATE
			-- To save the status of current.
		do
			create Result.make (Current)
		end

feature -- Element change

	set_split_position (a_position: INTEGER)
			-- Change split_position
		require
			positive_position: a_position >= 0
		do
			split_position := a_position
		end

	save_split_position
			-- Save the current splitter offset in `split_position'.
		require
			is_split: is_split
		do
--			if is_full then
				split_position := split_area.split_position
--			end
		end

	restore_split_position
			-- Set the EV_SPLIT_AREA's splitter offset to `split_position'.
		require
			is_split: is_split
		local
			sa: EV_SPLIT_AREA
		do
			sa := split_area
			if sa.full then
				if split_position < sa.minimum_split_position then
					sa.set_split_position (sa.minimum_split_position)
				elseif split_position > sa.maximum_split_position then
					sa.set_split_position (sa.maximum_split_position)
				else
					sa.set_split_position (split_position)
				end
			end
		end

	syncronize_buttons
			-- Make sure the state of the buttons and menu items agree with the status settings.
		do
				-- Fix radio items (radios are always selected on syncronize)
			radio_button.select_actions.block
			radio_item.select_actions.block
			radio_button.enable_select
			radio_item.enable_select
			radio_button.select_actions.resume
			radio_item.select_actions.resume
				-- Fix toggle buttons.	
			toggle_item.select_actions.block
			toggle_button.select_actions.block
			if is_visible then
				toggle_button.enable_select
				toggle_item.enable_select
			else
				toggle_button.disable_select
				toggle_item.disable_select
			end
			toggle_button.select_actions.resume
			toggle_item.select_actions.resume
		end

feature -- Status report

	is_visible: BOOLEAN
			-- Is `widget' visible?  (I.e. should it be shown?)
		do
			if is_view and not is_hidden and not is_disabled then
				Result := True
			elseif is_split then
				Result := first.is_branch_visible and second.is_branch_visible
			end
		end

	is_branch_visible: BOOLEAN
			-- Does the `first' or `second' have a visible branch (recursively)?
		do
			Result := not is_disabled and then ((is_view and not is_hidden) or else
						(is_split and then (first.is_branch_visible or second.is_branch_visible)))
		end

	is_hidden: BOOLEAN
			-- Is `widget' hidden?  Has the user hidden it?

	is_disabled: BOOLEAN
			-- Is `widget' not showable?

	is_selected: BOOLEAN
			-- Is `widget' the currently selected view?

feature -- Status setting

	hide
			-- Make `is_visible' false.
		require
			allowed_for_views_only: is_view
		do
			is_hidden := True
			syncronize_buttons
		end

	show
			-- Make `is_visible' true.
		require
			allowed_for_views_only: is_view
			not_disabled: not is_disabled
		do
			is_hidden := False
			syncronize_buttons
		end

	enable
			-- Make `is_disabled' False.  (Make the `widget' showable)
		require
			allowed_for_views_only: is_view
		do
			is_disabled := False
			syncronize_buttons
		end

	disable
			-- Make `is_disabled' True.
		require
			allowed_for_views_only: is_view
		do
			is_disabled := True
			syncronize_buttons
		ensure
			is_disabled: is_disabled
		end

	block_radio_actions
			-- The radio items cause problems with call backs when extended and removed
			-- from the toolbar or menu, therefore block the actions until the bar
			-- and menu is built.
			-- Just block all actions
		do
			radio_item.select_actions.block
			radio_button.select_actions.block
			toggle_item.select_actions.block
			toggle_button.select_actions.block
		end

	resume_radio_actions
			-- The radio items cause problems with call backs when extended and removed
			-- from the toolbar or menu, therefore block the actions until the bar
			-- and menu is built
		do
			radio_item.select_actions.resume
			radio_button.select_actions.resume
			toggle_item.select_actions.resume
			toggle_button.select_actions.resume
		end

feature -- Testing

	test_print (indent: INTEGER)
			-- Show on `io' for testing.
		local
			i: INTEGER
		do
			from i := 1
			until i > indent
			loop
				io.put_string ("%T")
				i := i + 1
			end
			io.put_string ("item = " + view.generating_type)
			io.put_string ("%T")
--			if is_split then
--				io.put_string ("is_split %T")
--				if is_visible then
--					io.put_string ("is_visible")
--				else
--					io.put_string ("NOT visible")
--				end
--				io.put_string ("%T")
--				if is_branch_visible then
--					io.put_string ("is_branch_visible")
--				else
--					io.put_string ("NOT is_branch_visible")
--				end
--			else
--				io.put_string ("NOT is_split")
--			end
			io.new_line
			if is_split then
				first.test_print (indent + 1)
				second.test_print (indent + 1)
			end
		end

feature {NONE} -- Implementation

	is_buttons_syncronized: BOOLEAN
			-- Does the state of each button reflect the objects state?
		require
			applies_to_view: is_view
		do
			Result := is_toggle_button_syncronized and then
						is_radio_button_syncronized and then
						is_toggle_item_syncronized and then
						is_radio_item_syncronized
		end

	is_toggle_button_syncronized: BOOLEAN
			-- Does the state of the `toggle_button' reflect the state of `is_visible'
		require
			applies_to_view: is_view
		do
			Result := is_visible implies toggle_button.is_selected
		end

	is_radio_button_syncronized: BOOLEAN
			-- Does the state of the `radio_button' reflect the state of `is_selected'
		require
			applies_to_view: is_view
		do
			Result := is_selected implies radio_button.is_selected
		end

	is_toggle_item_syncronized: BOOLEAN
			-- Does the state of the `toggle_item' reflect the state of `is_visible'
		require
			applies_to_view: is_view
		do
			Result := is_visible implies toggle_item.is_selected
		end

	is_radio_item_syncronized: BOOLEAN
			-- Does the state of the `radio_item' reflect the state of `is_selected'
		require
			applies_to_view: is_view
		do
			Result := is_visible implies toggle_button.is_selected
		end

invariant

	view_has_buttons: is_view implies
		 (toggle_button /= Void and radio_button /= Void and toggle_item /= Void and radio_item /= Void)

end
