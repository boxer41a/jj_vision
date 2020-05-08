note
	description: "[
		Used by the {DIALOG_EDITOR_VIEW} to hold an {EDITOR_FIXED}.  This was
		a functional decomposition of the dialog editor in order to simplify
		scrolling, sizing of the fixed area, and of positioning of controls.
		Note:  the creation of controls and reacting to events on the 
		controls is handled elsewhere.
		]"
	date: "23 Feb 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/editor_scroll_area.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	EDITOR_SCROLL_AREA

inherit

	EV_STOCK_COLORS
		rename
			implementation as colors_implementation
		export
			{NONE} all
		undefine
			default_create,
			is_equal,
			copy
		end

	EV_SCROLLABLE_AREA
		redefine
			initialize
--			item
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
			-- Create an instance
		local
			f: EDITOR_FIXED
		do
			Precursor {EV_SCROLLABLE_AREA}
			create f
			extend (f)
			set_actions
		end

	set_actions
			-- Add actions to current
		do
			resize_actions.extend (agent resize_fixed)
		end

feature -- Access

--	item: EDITOR_FIXED is
--			-- Redefined to change type to a EDITOR_FIXED so it
--			-- can be used for custom placement of the controls.
--		do
--			Result ?= Precursor {EV_SCROLLABLE_AREA}
--		ensure then
--			valid_result: Result /= Void
--		end

feature -- Basic operations

	position_control (a_control: CONTROL)
			-- Place `a_control' in the correct spot based on info
			-- in the control's `field'.
			-- Has no effect if `a_control' is not in Current (in `fixed')
		require
			control_exists: a_control /= Void
		local
			f: FIELD
		do
			check attached {EDITOR_FIXED} item as ef then
						-- because currents should only hold and EDITOR_FIXED.
				if ef.has (a_control) then
					a_control.build
							-- `a_control.draw' sets the minimum size
							-- of `a_control' then `fixed.set_item_size'
							-- changes the "actual size" of `a_control'.
					ef.set_item_width (a_control, a_control.minimum_width)
					ef.set_item_height (a_control, a_control.minimum_height)
							-- Now use the values in the FIELDs of `a_control'
							-- to set its position in the page.
					f := a_control.field
					ef.set_item_position (a_control, f.x.item, f.y.item)
							-- Call `resized_fixed' to make the scrollbars in
							-- current agree with the new size.
							-- This does a lot of re-parenting so ineficient, but
							-- if ISE can tell me how to get VIEWPORT.`set_item_size',
							-- which was attempted in `resize_fixed', to work then this
							-- line can probably come out.
					resize_fixed (0,0,0,0)	-- the parameters are not used
				end
			end
		end

feature {NONE} -- Implementation

	resize_fixed (a_x, a_y, a_width, a_height: INTEGER)
			-- Change the size of `item' to be at least as big as this
			-- scroll area but no bigger than needed based on the
			-- controls in `item'.
			-- The parameters are there so the feature has the correct
			-- signature but are not used in the calculations.
		local
			x_max, y_max: INTEGER
		do
--				-- Must check for parent because `parent_window' makes no
--				-- since if Current is not contained in some container.
--			if parent_window (Current) /= Void then
--					-- This feature is ineficient as is because of all the
--					-- re-parenting that is going on.
--					-- Must `lock_update' from EV_WINDOW to prevent
--					-- severe flickering on all the re-parenting.
--				parent_window (Current).lock_update
--					-- Block the actions so don't get infinite loop
--				resize_actions.block
--					-- Create a new fixed with the correct size to
--					-- replace the wrong sized one.
--				create f
--					-- Transfer all the controls to the new fixed
--				from item.start
--				until item.exhausted
--				loop
--					c := item.item
--					item.remove
--					f.extend (c)
--				end
--					-- Put any actions in `fixed' into the new fixed `f'.
--				f.conforming_pick_actions.merge_right (item.conforming_pick_actions)
--				f.drop_actions.merge_right (item.drop_actions)
--				f.pick_actions.merge_right (item.pick_actions)
--				f.pick_ended_actions.merge_right (item.pick_ended_actions)
--				f.focus_in_actions.merge_right (item.focus_in_actions)
--				f.key_press_actions.merge_right (item.key_press_actions)
--				f.key_press_string_actions.merge_right (item.key_press_string_actions)
--				f.key_release_actions.merge_right (item.key_release_actions)
--				f.pointer_button_press_actions.merge_right (item.pointer_button_press_actions)
--				f.pointer_button_release_actions.merge_right (item.pointer_button_release_actions)
--				f.pointer_double_press_actions.merge_right (item.pointer_double_press_actions)
--				f.pointer_enter_actions.merge_right (item.pointer_enter_actions)
--				f.pointer_leave_actions.merge_right (item.pointer_leave_actions)
--				f.pointer_motion_actions.merge_right (item.pointer_motion_actions)
--				f.resize_actions.merge_right (item.resize_actions)
--					-- Replace `fixed' with the new fixed, `f'.
--				replace (f)
--					-- Make the size of fixed at least as big as Current.
--				f.set_minimum_size (client_width, client_height)
--				resize_actions.resume
--				parent_window (Current).unlock_update
--			end
					-- From here down would be used if `set_item_size' from
					-- VIEWPORT worked properly.  As of 26 Nov 02 ISE can not
					-- answer why I get a post-condition violation on the
					-- feature even though it passes the pre-conditions.
					-- The calls to `item.set_minimum_width (50) were there
					-- for testing a probably not needed if `set_item_size'
					-- ever works.
			if readable then
				check attached {EDITOR_FIXED} item as ef then
							-- Because current should only hold EDITOR_FIXED widgets.
					from ef.start
					until ef.exhausted
					loop
						check attached {CONTROL} ef.item as c then
								-- Because all these items should be CONTROLs.
							x_max := (c.x_position + c.width).max (x_max)
							y_max := (c.y_position + c.height).max (y_max)
							ef.forth
						end
					end
				end
				item.set_minimum_width (0)
				item.set_minimum_height (0)
				if x_max < width then
					set_item_width (width)
				else
					set_item_width (x_max)
				end
				if y_max < height then
					set_item_height (height)
				else
					set_item_height (y_max)
				end
			end
		end

feature {NONE} -- Implementation

	parent_window (a_containable: EV_CONTAINABLE): EV_WINDOW
			-- The EV_WINDOW, if any, which contains Current.
			-- This recursive procedure was provided by Julian Rodgers
			-- from the Eiffel users group.
		require
			cotainable_has_parent: a_containable.parent /= Void
		do
			check attached {EV_CONTAINER} a_containable.parent as cur_parent then
					-- because parent of EV_CONTAINABLE must be an EV_CONTAINER
				if attached {EV_WINDOW} cur_parent as w then
					Result := w
				else
					check attached {EV_CONTAINABLE} cur_parent as con_parent then
							-- because, if not an EV_WINDOW it must be EV_CONTAINABLE
						Result := parent_window (con_parent)
					end
				end
			end
		end

end
