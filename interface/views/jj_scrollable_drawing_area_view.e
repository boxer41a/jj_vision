note
	description	: "[
		This class ties together the concept of EV_MODEL_WORLD, EV_DRAWING_AREA,
		and EV_MODEL_DRAWING_AREA_PROJECTOR in a simpler interface.  The drawing
		area is contained in an EV_FIXED within an EV_SCROLLABLE_AREA,
		allowing the
		]"
	date: "18 Jul 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/jj_scrollable_drawing_area_view.e $"
	date:		"$Date: 2012-06-11 16:54:43 -0400 (Mon, 11 Jun 2012) $"
	revision:	"$Revision: 11 $"

class
	JJ_SCROLLABLE_DRAWING_AREA_VIEW

inherit

	VIEW
		undefine
			copy
		redefine
			create_interface_objects,
			initialize,
			draw
		end

	EV_SCROLLABLE_AREA
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {VIEW}
			Precursor {EV_SCROLLABLE_AREA}
			create fixed
			create world
			create drawing_area
			create projector.make (world, drawing_area)
		end

	initialize
			-- Set up the widget
		do
			Precursor {VIEW}
			Precursor {EV_SCROLLABLE_AREA}
			extend (fixed)
			fixed.extend (drawing_area)
			set_actions
		end

	set_actions
		do
			resize_actions.force_extend (agent draw)
			resize_actions.extend (agent resize_fixed)
		end

feature -- Access

	world: EV_FIGURE_WORLD
			-- World which Current will manipulate.

	drawing_area: EV_DRAWING_AREA
			-- Area on which `world' will be projected.
			-- It is contained within a `fixed' area of Current.
			-- Exported to allow direct drawing on it.

feature -- Element change

	set_world (a_world: EV_FIGURE_WORLD)
			-- Change the `world' of figures to be displayed
		require
			world_exists: a_world /= Void
		do
			world := a_world
			projector.set_world (a_world)
		end

feature {NONE} -- Drawing / Refresh operations

	resize_fixed (a_x, a_y, a_width, a_height: INTEGER)
			-- Change the size of `drawing_area' to be at least as big as the
			-- scroll area but no bigger, by removing the old one area re-
			-- extending it into `fixed'.
			-- The parameters are there so the feature has the correct
			-- signature but are not used in the calculations.
		local
			big_x, big_y: INTEGER
			f: like fixed
		do
				-- Must check for parent because `parent_window' makes no
				-- since if Current is not contained in some container.
			if parent_window /= Void then
					-- This feature is ineficient as is because of all the
					-- re-parenting that is going on.
					-- Must `lock_update' from EV_WINDOW to prevent
					-- severe flickering on all the re-parenting.
				parent_window.lock_update
					-- Block the actions so don't get infinite loop
				resize_actions.block
					-- Create a new fixed with the correct size to
					-- replace the wrong sized one.
				create f
					-- Transfer all the `drawing_area' to the new fixed
					-- For some reason the `drawing_area' does not always have
					-- parent `fixed' as expected; hence all the checks and the
					-- statement to make the parent of `drawing_area' call `prune'.
				fixed.start
				fixed.prune (drawing_area)
				check
					not fixed.has (drawing_area)
				end
				if attached {EV_CONTAINER} drawing_area.parent as p then
					p.prune (drawing_area)
				end
				check
					drawing_area.parent = Void
				end
				f.extend (drawing_area)
					-- Put any actions in `fixed' into the new fixed `f'.
				f.conforming_pick_actions.merge_right (fixed.conforming_pick_actions)
				f.drop_actions.merge_right (fixed.drop_actions)
				f.pick_actions.merge_right (fixed.pick_actions)
				f.pick_ended_actions.merge_right (fixed.pick_ended_actions)
				f.focus_in_actions.merge_right (fixed.focus_in_actions)
				f.key_press_actions.merge_right (fixed.key_press_actions)
				f.key_press_string_actions.merge_right (fixed.key_press_string_actions)
				f.key_release_actions.merge_right (fixed.key_release_actions)
				f.pointer_button_press_actions.merge_right (fixed.pointer_button_press_actions)
				f.pointer_button_release_actions.merge_right (fixed.pointer_button_release_actions)
				f.pointer_double_press_actions.merge_right (fixed.pointer_double_press_actions)
				f.pointer_enter_actions.merge_right (fixed.pointer_enter_actions)
				f.pointer_leave_actions.merge_right (fixed.pointer_leave_actions)
				f.pointer_motion_actions.merge_right (fixed.pointer_motion_actions)
				f.resize_actions.merge_right (fixed.resize_actions)
					-- Replace `fixed' with the new fixed, `f'.
				replace (f)
					-- Make the size of `drawing_area' at least as big as Current.
				f.set_item_size (drawing_area, client_width.max (world.bounding_box.width), client_height.max (world.bounding_box.height))
--				f.set_item_size (drawing_area, width.max (world.bounding_box.width), height.max (world.bounding_box.height))
				resize_actions.resume
				parent_window.unlock_update
			end
					-- From here down would be used if `set_item_size' from
					-- VIEWPORT worked properly.  As of 26 Nov 02 ISE can not
					-- answer why I get a post-condition violation on the
					-- feature even though it passes the pre-conditions.
					-- The calls to `item.set_minimum_width (50) were there
					-- for testing and probably not needed if `set_item_size'
					-- ever works.
----			from item.start
----			until item.exhausted
----			loop
----				c := item.item
----				big_x := (c.x_position + c.width).max (big_x)
----				big_y := (c.y_position + c.height).max (big_y)
----				item.forth
----			end
--			item.set_minimum_width (50)
--			item.set_minimum_height (50)
--			item.set_minimum_width (25)
----			if big_x < client_width or big_y < client_height then
------				if big_x < client_width then
------					set_item_width (client_width)
------				end
----				if big_y < client_height then
----					set_item_height (client_height)
----				end
------				set_item_size (client_width, client_height)
----				item.set_minimum_size (client_width, client_height)
----			else
----				set_item_size (big_x, big_y)
------				item.set_minimum_size (big_x, big_y)
----			end
		end

	draw
			-- Build the view
		do
			drawing_area.clear
			if projector /= Void then
				projector.full_project
			end
		end

feature {NONE} -- Implementation

	projector: EV_DRAWING_AREA_PROJECTOR
			-- For projecting the world onto the drawing area.

	fixed: EV_FIXED
			-- Container placed in the EV_FRAME to facilitate
			-- the placement of scrollbars and other widgets.

end

