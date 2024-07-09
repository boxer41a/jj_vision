note
	description: "[
		Used as common ancestor to all "windows" in a system built using the
		"jj_vision" cluster.  It provides a way through feature `draw_views'
		for updating all the views which contain that `target'.
		Alternatively, the view
		can force the redraw of views containing any of several objects by passing
		a set of changed objects to feature `draw_views_with_set'.
		The class should be an ancestor ancestor along with
		some effected EV_WIDGET.
		NOTE:  Views which are `is_destroyed' are removed from the global `views' set
		in feature `draw_views'.
		]"
	date: "18 Jul 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/view.e $"
	date:		"$Date: 2015-10-24 07:32:40 -0700 (Sat, 24 Oct 2015) $"
	revision:	"$Revision: 23 $"

deferred class
	VIEW

inherit

	DIMABLE
		undefine
			default_create
		redefine
			set_dimming_level
		end

	SHARED
		undefine
			default_create
		end

	PIXEL_BUFFERS
		undefine
			default_create
		end

--create
--	make

feature {NONE} -- Initialization

	make (a_target: like target)
			-- Create a new view to display `a_target'
		do
				-- This assignment is required to avoid violating a
				-- precondition "not_empty" later when calling
				-- feature `create_interface_objects".
			target_imp := a_target
				-- `default_create from:
				-- 1) {EV_ANY} calls `create_interface_objects', later `initialize'
				-- 2) {EV_MODEL calls only `create_interface_objects'
			default_create
			set_target (a_target)	-- calls `draw'
--			draw
		end

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation
			-- bridge pattern.
			-- Called by `default_create' from {EV_ANY} or {EV_MODEL}
		require
			not_interface_objects_created: not is_interface_objects_created
		do
			create pixmap.make_with_pixel_buffer (Icon_new_class_color_buffer)
			is_interface_objects_created := true
		ensure
			interface_objects_created: is_interface_objects_created
		end

	initialize
			-- Initialize the view and insert it into a global list of views.
		require
			view_not_initialized: not is_view_initialized
		do
--			initialize_dimable
			dimming_level := Dim
			previous_dimming_level := Dimmer
			add_actions
			is_view_initialized := True
		ensure
			initialized: is_view_initialized
		end

	add_actions
			-- Add any actions to Current.
		require
			not_initialized: not is_view_initialized
		do
			pointer_button_press_actions.extend (agent on_prepick_right_click)
			pick_actions.extend (agent on_picked)
			pointer_motion_actions.extend (agent on_postput_move)
		end

feature -- Status report

	is_interface_objects_created: BOOLEAN
			-- Has `create_interface_objects' been called?

	is_view_initialized: BOOLEAN
			-- Has `initialize' been called?

	is_pick_notifiable: BOOLEAN
			-- Should Current be notified by other views (normally
			-- a view contained in Current) that some event has
			-- occurred?
			-- Feature `set_parent_view' must have been called on
			-- the child view for this to take effect.

	has_parent_view: BOOLEAN
			-- Does Current know the view in which it resides?
		do
			Result := attached parent_view_imp
		end

feature -- Access

	application: JJ_APPLICATION
			-- The application in which Current resides.
		do
			check attached {JJ_APPLICATION} (create {EV_ENVIRONMENT}).application as app then
					-- because this class is for use in a {JJ_APPLICATION}.
				Result := app
			end
		end

	pixmap: EV_PIXMAP
			-- The pixmap associated with this view

--	application: JJ_APPLICATION is
--			-- Convience feature for obtaining the current application.
--		local
--			app: JJ_APPLICATION
--		once
--			app ?= (create {EV_ENVIRONMENT}).application
--			check
--				jj_application_exists: app /= Void
--					-- Because VIEWs are used in JJ_APPLICATIONs.
--			end
--		ensure
--			result_exists: Result /= Void
--		end

--	command_manager: COMMAND_MANAGER is
--			-- Manages the COMMAND's called by the system to allow undo/redo capabilities.
--			-- (This is a handle to the `command_manager' from a JJ_APPLICATION; putting it
--			-- here instead of in SHARED allows redefinition of the `command_manager' in
--			-- descendents of JJ_APPLICATION.
--		once
--			Result := application.command_manager
--		end

	frozen target: attached like target_imp
			-- The primary target in this view.  This feature along with
			-- `set_target' allows the view to handle one target specially.
		require
			not_empty: not is_view_empty
		do
			check attached target_imp as t then
				Result := t
			end
		end

	parent_window: JJ_MAIN_WINDOW
			-- The {JJ_MAIN_WINDOW} if any which contains this view.
			-- Must redefine to change type.
		do
			check attached {EV_CONTAINABLE} Current as c then
				Result := recursive_parent_window (c)
			end
		ensure
			valid_result: Result /= Void
		end

	parent_tool: detachable TOOL
			-- The TOOL, if any, in which Current resides.
		local
			con: detachable EV_CONTAINER
		do
			from con := parent
			until Result /= Void or else con = Void
			loop
				if attached {TOOL} con as t then
					Result := t
				else
					con := con.parent
				end
			end
		end

	parent_view: attached like parent_view_imp
			-- The view in which Current resides.
			-- Provides a way for a model view to notify a parent
			-- container of changes
		require
			has_parent_view: has_parent_view
		do
			check attached parent_view_imp as p then
				Result := p
			end
		end

	parent: detachable EV_CONTAINER
			-- Parent of the current view.
			-- To be effected by joining with an EV_ class
		deferred
		end

	state: VIEW_STATE
			-- A snapshot of the current look of the view
		do
			create Result.make (Current)
		end

feature -- Element change

	set_target (a_target: like target)
			-- Change the value of `target' and realign the table or list
			-- of views in which `a_target' is displayed.
		do
--			print ("VIEW.set_target:  a_target = " + target.out + "%N")
				-- Remove the old association
			if attached target_imp and then target /= a_target then
				check
					has_associated_view: views_table.has (target)
						-- because `target_imp' not Void and `make'
				end
				views_table.prune (Current)
				target_imp := Void
			end
			if target_imp = Void then
					-- the expected case, except of initial creation
--				print ("VIEW.set_target:  if statement target_imp = Void %N")
				target_imp := a_target
				views_table.extend (Current)
			elseif not views_table.has_view (Current) then
--				print ("VIEW.set_target:  not views_table.has (Current) %N")
				check
					same_object: target_imp = a_target
						-- because of assignment statement in `make'
				end
				views_table.extend (Current)
			end
			draw
		ensure
			has_target: has_target (a_target)
		end

	set_parent_view (a_view: VIEW)
			-- Set `parent_view' to `a_view', allowing Current to
			-- notify `a_view' of some event (e.g. right click).
		do
			parent_view_imp := a_view
		end

	set_dimming_level (a_level: like dimming_level)
			-- Change the `dimming_level'
		do
			Precursor (a_level)
--			paint
		end

feature -- Basic operations

--	paint
--			-- Draw the current view when some property like
--			-- background color changes
--		do
--		end

	draw
			-- Draw the current view.
			-- Default does nothing
		require
			view_is_drawable: not is_draw_disabled
		do
		end

	draw_other_views (a_target: ANY)
			-- Draw all views that contain `a_target' except Current
			-- This also cleans any "destroyed" views from the `views' set.
		require
			target_exists: a_target /= Void
		local
			b: BOOLEAN
		do
			b := is_draw_disabled
			disable_drawing
			draw_views (a_target)
			if not b then
				enable_drawing
			end
		end

	draw_views (a_target: ANY)
			-- Draw the views which contain `a_target'.
		local
			lin: LINEAR [VIEW]
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
		do
			create marks.make
			lin := views_table.linear (a_target)
			from lin.start
			until lin.after
			loop
				v := lin.item
				if v.is_destroyed then
					marks.extend (v)
				elseif not v.is_draw_disabled then
					v.draw
				end
				lin.forth
			end
				-- Clean out any views that are no longer usable.
			from marks.start
			until marks.exhausted
			loop
				views_table.prune (marks.item)
				marks.forth
			end
		end

	draw_views_with_set (a_set: LINEAR [ANY])
			-- Draw the views which contain any of the objects in `a_set'.
			-- This also cleans any "destroyed" views from the `views' set.
		require
			set_exists: a_set /= Void
		local
			lin: LINEAR [VIEW]
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
		do
			create marks.make
			lin := views_table.linear_with_set (a_set)
			from lin.start
			until lin.after
			loop
				v := lin.item
				if v.is_destroyed then
					marks.extend (v)
				elseif not v.is_draw_disabled then
					v.draw
				end
				lin.forth
			end
				-- Clean out any views that are no longer usable.
			from marks.start
			until marks.exhausted
			loop
				views_table.prune (marks.item)
				marks.forth
			end
		end

	draw_all_views
			-- Draw *all* the views in the system.
			-- Also cleans any "destroyed" views for the `views' set.
		local
			lin: LINEAR [VIEW]
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
		do
			create marks.make
			lin := views_table.linear_representation
			from lin.start
			until lin.after
			loop
				v := lin.item
				if v.is_destroyed then
					marks.extend (v)
				elseif not v.is_draw_disabled then
					v.draw
				end
				lin.forth
			end
				-- Clean out any views that are no longer usable.
			from marks.start
			until marks.exhausted
			loop
				views_table.prune (marks.item)
				marks.forth
			end
		end

feature -- Status report

	is_in_default_state: BOOLEAN = true
			-- Is `Current' in its default state?
			-- The intent of this class is to be joined with an EV_WIDGET.
			-- The default state of a descendent is most likely not the same
			-- as the default state of the parent EV_WIDGET (after all, a
			-- new type widget is being defined that, by definition looks
			-- different from the parent.)
			-- This silly feature is the post-condition of `default_create'
			-- from EV_WIDGET, which required a choice--either redefine this
			-- feature in every EV_WIDGET descendant or, as chosen here, use
			-- this version (the EV_WIDGET version is irrelavent anyway) and
			-- undefine it in the inherit class of the EV_WIDGET parent.

	is_destroyed: BOOLEAN
			-- Has the view been destroyed?
			-- This will be joined with an EV_WIDGET feature
		deferred
		end

	is_view_empty: BOOLEAN
			-- Are there no objects in this VIEW?
		do
			Result := target_imp = Void
		end

	is_draw_disabled: BOOLEAN
			-- Can the view be drawn using 'draw'?

feature -- Status setting

	disable_drawing
			-- Block the view from being redrawn by calling draw.
			-- Used to reduce number of calls to draw.
		do
			is_draw_disabled := True
		ensure
			drawing_not_allowed: is_draw_disabled
		end

	enable_drawing
			-- Allow the view to be redrawn on a call to draw.
		do
			is_draw_disabled := False
		ensure
			drawing_allowed: not is_draw_disabled
		end

feature -- Query

	has_target (a_target: like target): BOOLEAN
			-- Does Current contain `a_target'?
		do
			Result := target_imp = a_target
		end

	display_name (a_object: ANY): STRING
			-- An identifying "out" value corresponding to `a_object'.
		require
			object_exists: a_object /= Void
		do
			if attached {EDITABLE} a_object as e then
				Result := e.display_name
			else
				Result := "fix me"
				print ("VIEW.display_name -- get from once table?")
			end
		ensure
			result_exists: Result /= Void
		end

	yes_cursor (a_target: ANY): EV_POINTER_STYLE
			-- Cursor for `a_target'.
		do
			create Result.make_with_pixel_buffer (Icon_new_class_color_buffer, 0, 0)
		end

	no_cursor (a_target: ANY): EV_CURSOR
			-- Cursor for `a_target'.
		do
			create Result
		end

	linear (a_object: ANY): LINEAR [VIEW]
			-- List of views in which `a_object' is displayed.  The
			-- resulting list could be empty.
		do
			Result := views_table.linear (a_object)
		end

	linear_with_set (a_set: LINEAR [ANY]): LINEAR [VIEW]
			-- List of views in which any of the objects in `a_set'
			-- is displayed.
		do
			Result := views_table.linear_with_set (a_set)
		end

	frozen post_pick_move_agent: PROCEDURE [TUPLE [a_x, a_y: INTEGER;
								 a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
								 a_screen_x, a_screen_y: INTEGER]]
			-- Creates an agent out of `on_postput_move' which is added to
			-- the `pointer_motion_actions' of *ALL* views when a pick occurs
			-- (see `on_picked').  Holding on to this agent as a once feature
			-- allows `on_postput_move' to remove this agent from *ALL* the
			-- views after the pick has ended and the mouse is moved [in one
			-- of the views].
		once
			Result := agent on_postput_move
		end

feature -- Basic operations

	target_changed_operations
			-- This feature is called by `notify_views' to perform
			-- actions when that view's `target' was modified.
		do
			print ("{VIEW}.target_changed_operations %N")

		end

	pick_notified_operations (a_target: ANY)
			-- React to the pick of `a_target' from some view
		do
			print ("{VIEW}.pick_notified_operations on {" + generating_type.name + "}%N")

		end

	pick_ended_operations
			-- React to the end of a pick and drop operation
		do
			print ("{VIEW}.pick_ended_operations on {" + generating_type.name + "} %N")

		end

	child_object_changed_operations (a_target: ANY)
			-- React to a change of `a_target' in one of the child
			-- views of Current
		require
--			is_parent
		do
			print ("VIEW.child_object_changed_operations %N")
		end

	notify_views (a_target: ANY)
			-- Inform the views that have `a_target' that `a_target'
			-- has changed (i.e. call `target_changed_operations' for
			-- those views).
			-- This also cleans any "destroyed" views from the `views' set.
		local
			lin: LINEAR [VIEW]
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
		do
			create marks.make
			lin := views_table.linear (a_target)
			from lin.start
			until lin.after
			loop
				v := lin.item
				if v.is_destroyed then
					marks.extend (v)
				elseif not v.is_draw_disabled then
					v.target_changed_operations
				end
				lin.forth
			end
				-- Clean out any views that are no longer usable.
			from marks.start
			until marks.exhausted
			loop
				views_table.prune (marks.item)
				marks.forth
			end
		end

	notify_parents (a_target: ANY)
			-- Inform the parent-views of any view that that have\
			-- `a_target' that `a_target' has changed.
		local
			lin: LINEAR [VIEW]
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
			pv: VIEW
		do
			create marks.make
			lin := views_table.linear (a_target)
			from lin.start
			until lin.after
			loop
				v := lin.item
				if v.has_parent_view then
					pv := v.parent_view
					pv.child_object_changed_operations (a_target)
				end
				lin.forth
			end
				-- Clean out any views that are no longer usable.
			from marks.start
			until marks.exhausted
			loop
				views_table.prune (marks.item)
				marks.forth
			end
		end

feature {NONE} -- Agents and support (actions)

	frozen on_prepick_right_click (x, y, button: INTEGER;
								x_tilt, y_tilt, pressure: DOUBLE;
								screen_x, screen_y: INTEGER)
			-- Notify the parent of all views that contain `target'
			-- that a pick event occurred involving `target'.
		local
			lin: LINEAR [VIEW]
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
		do
--			is_picking.set_item (true)
			create marks.make
			lin := views_table.linear (target)
			from lin.start
			until lin.after
			loop
				v := lin.item
				if v.is_destroyed then
					marks.extend (v)
				elseif v.has_parent_view then
						-- Notifiy the parent view of the pick
					v.parent_view.pick_notified_operations (target)
						-- Save the view for notification when pick ends
					pick_notified_views.extend (v.parent_view)
				end
				lin.forth
			end
				-- Clean out any views that are no longer usable.
			from marks.start
			until marks.exhausted
			loop
				views_table.prune (marks.item)
				marks.forth
			end
		end

	frozen on_picked (a_x, a_y: INTEGER)
			-- Notify the parent of all views that contain `target'
			-- that a pick event occurred involving `target'.
		local
			lin: LINEAR [VIEW]
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
		do
			is_picking.set_item (true)
--			create marks.make
--			lin := views_table.linear (target)
--			from lin.start
--			until lin.after
--			loop
--				v := lin.item
--				if v.is_destroyed then
--					marks.extend (v)
--				elseif v.has_parent_view then
--						-- Notifiy the parent view of the pick
--					v.parent_view.pick_notified_operations (target)
--						-- Save the view for notification when pick ends
--					pick_notified_views.extend (v.parent_view)
--				end
--				lin.forth
--			end
--				-- Clean out any views that are no longer usable.
--			from marks.start
--			until marks.exhausted
--			loop
--				views_table.prune (marks.item)
--				marks.forth
--			end
		end

	frozen on_postput_move (a_x, a_y: INTEGER;
								 a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
								 a_screen_x, a_screen_y: INTEGER)
			-- Feature added as agent to `pointer_motion_actions'
			-- to react after a pnp operations has ended.  It calls
			-- feature `postput_operations'.
			-- Redefine `postput_operations' to clean up any operations
			-- that occurred in `do_prepick_operations'.
			-- See index clause for information on pick-and-put.
		local
 			v: VIEW
		do
			print ("{VIEW}.on_postput_move  on " + generating_type.name + "%N")
				-- Notify views when a transport has ended.
			if is_picking.item and then not application.transport_in_progress then
				print ("%T `is_picking and not transport_in_progress   pick_notified_views.count = " + pick_notified_views.count.out + "%N")
				is_picking.set_item (false)
					-- Inform any parent views that the pick has ended
				from pick_notified_views.start
				until pick_notified_views.after
				loop
					v := pick_notified_views.item
					v.pick_ended_operations
					pick_notified_views.forth
				end
				pick_notified_views.wipe_out
			end
		end

	frozen is_picking: BOOLEAN_REF
			-- Is a pick-and-put (PNP) operation in progress?
			-- It seems the PNP operations intercepts events system-
			-- wide, so this is a global reference.
			-- See index clause for information on pick-and-put.
		once
			create Result
		end

	pick_notified_views: LINKED_SET [VIEW]
			-- List of views that were notfied by `on_picked'
		once
			create Result.make
		end

feature -- Action sequences

	pointer_button_press_actions: EV_POINTER_BUTTON_ACTION_SEQUENCE
			-- Actions to be performed when screen pointer button is pressed.
			-- Defined here as place-holder to be undefined (i.e. joined) to
			-- the version from {EV_WIDGET} or {EV_MODEL}.
			-- See index clause for information on pick-and-put.
		deferred
		end

	pointer_motion_actions: EV_POINTER_MOTION_ACTION_SEQUENCE
			-- Actions to be performed when screen pointer moves.
			-- Defined here as place-holder to be undefined (i.e. joined) to
			-- the version from {EV_WIDGET} or {EV_MODEL}.
			-- See index clause for information on pick-and-put.
		deferred
		end

	pick_actions: EV_PND_START_ACTION_SEQUENCE
			-- Actions to be performed when `pebble' is picked up.
			-- Defined here as place-holder to be undefined by some
			-- {EV_WIDGET} or {EV_MODEL}.
		deferred
		end

	drop_actions: EV_PND_ACTION_SEQUENCE	--EV_PND_START_ACTION_SEQUENCE
			-- Actions to be performed when a pebble is dropped here.
		deferred
		end

feature {NONE} -- Implementation

	recursive_parent_window (a_containable: EV_CONTAINABLE): JJ_MAIN_WINDOW
			-- The {JJ_MAIN_WINDOW} which contains this tool.
			-- This procedure was provided by Julian Rodgers from the Eiffel
			-- users group.
		do
			check attached {EV_CONTAINER} a_containable.parent as cur_parent then
					-- because parent of EV_CONTAINABLE must be an EV_CONTAINER
				if attached {JJ_MAIN_WINDOW} cur_parent as w then
					Result := w
				else
					check attached {EV_CONTAINABLE} cur_parent as con_parent then
							-- because, if `cur_parent' is not a {JJ_MAIN_WINDOW} it must be EV_CONTAINABLE
						Result := recursive_parent_window (con_parent)
					end
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Implemetation

	target_imp: detachable ANY
			-- Detachable implementation of `target' for void safety

	views_table: VIEW_TARGET_TABLE
			-- Global table associating objects to views
		once
			create Result
		end

	parent_view_imp: detachable VIEW
			-- Detachable implementation of `parent_view'

invariant

--	not_empty: target_imp /= Void

end
