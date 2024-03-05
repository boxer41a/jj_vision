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
			set_target (a_target)
			draw
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
			add_actions
			is_view_initialized := True
		ensure
			initialized: is_view_initialized
		end

	add_actions
			-- Add any actions to Current.
			-- Called by `initialize'.
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
			-- Has the view been set up?

feature -- Access

	application: JJ_APPLICATION
			-- The application in which Current resides.
		do
			check attached {JJ_APPLICATION} (create {EV_ENVIRONMENT}).application as app then
					-- because {JJ_MAIN_WINDOW} (this class) is for use in a {JJ_APPLICATION}.
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
				target_imp := a_target
				views_table.extend (Current)
			elseif not views_table.has_view (Current) then
				check
					same_object: target_imp = a_target
						-- because of assignment statement in `make'
				end
				views_table.extend (Current)
			end
		ensure
			has_target: has_target (a_target)
		end

feature -- Basic operations

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

	yes_cursor (a_target: ANY): EV_CURSOR
			-- Cursor for `a_target'.
		do
--			Result.make_with_pixmap (
			create Result
		end

	no_cursor (a_target: ANY): EV_CURSOR
			-- Cursor for `a_target'.
		do
			create Result
		end

feature -- Basic operations

	prepick_operations
			-- Feature called just before a pick-and-put (PNP)
			-- operation starts (i.e. when a right-click occurs).
			-- See index clause for information on pick-and-put.
		do
			print (generating_type.name + ".prepick_operations %N")
		end

	postput_operations
			-- Feature called just after a pick-and-put (PNP)
			-- operation ends.  The end (either a drop or a cancel)
			-- of a PNP operations is detected when a mouse-move
			-- event occurs.)
			-- See index clause for information on pick-and-put.
		do
			print (generating_type.name + ".postpick_operations %N")
		end


feature {NONE} -- Agents and support (actions)

	is_picking: BOOLEAN_REF
			-- Is a pick-and-put (PNP) operation in progress?
			-- It seems the PNP operations intercepts events system-
			-- wide, so this is a global reference.
			-- See index clause for information on pick-and-put.
		once
			create Result
		end

	on_prepick_right_click (a_x, a_y, a_button: INTEGER;
								 a_x_tilt, a_y_tilt, a_pressure: DOUBLE;
								 a_screen_x, a_screen_y: INTEGER)
			-- Feature added as agent to `pointer_button_press_actions' to
			-- react to a right-click in order to call `prepick_operations'
			-- right before a PNP begins.  (Feature `pick_actions' does not
			-- allow some views to show their updates until the pebble
			-- transport is complete.)
		local
			lin: like views_table.linear_representation
			v: VIEW
		do
			lin := views_table.linear_representation
			if a_button = 3 then
				prepick_operations
--				is_picking.set_item (true)
				from lin.start
				until lin.after
				loop
					v := lin.item
					v.pointer_motion_actions.extend (post_pick_move_agent)
					lin.forth
				end
			end
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
			lin: like views_table.linear_representation
			v: VIEW
		do
			lin := views_table.linear_representation
			if is_picking.item then
				postput_operations
				is_picking.set_item (false)
					-- Remove this feature (the agent) from move actions
				from lin.start
				until lin.after
				loop
					v := lin.item
					v.pointer_motion_actions.prune (post_pick_move_agent)
					lin.forth
				end
			end
		end

	on_picked (a_x, a_y: INTEGER)
			-- Do something when a pick happens
		do
			is_picking.set_item (true)
				-- Even though `prepick_operations' executes, the EV_MODELs
				-- in the views do not reflect changes until he transport is
				-- over, at which time `on_postput_move' is called reversing
				-- the changes.  It appears as if nothing changed.
--			prepick_operations
--			is_picking.set_item (true)
--			from views.start
--			until views.after
--			loop
--				list := views.item_for_iteration
--				from list.start
--				until list.after
--				loop
--					v := list.item_for_iteration
--					v.pointer_motion_actions.extend (post_pick_move_agent)
--					list.forth
--				end
--				views.forth
--			end
		end

	post_pick_move_agent: PROCEDURE [TUPLE [a_x, a_y: INTEGER;
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

feature -- Action sequences

	pointer_button_press_actions: EV_POINTER_BUTTON_ACTION_SEQUENCE
			-- Actions to be performed when screen pointer button is pressed.
			-- Defined here as place-holder to be undefined (i.e. joined) to
			-- the version from {EV_WIDGET} or {EV_MODEL}.
			-- See index clause for information on pick-and-put.
		deferred
		end
--		do
--			create Result
--			check
--				do_not_call: false
--					-- Because this feature should be UNDEFINED and the
--					-- version from {EV_WIDGET} or {EV_MODEL} called.
--			end
--		end

	pointer_button_release_actions: EV_POINTER_BUTTON_ACTION_SEQUENCE
			-- Actions to be performed when screen pointer button is pressed.
			-- Defined here as place-holder to be undefined (i.e. joined) to
			-- the version from {EV_WIDGET} or {EV_MODEL}.
			-- See index clause for information on pick-and-put.
		deferred
		end
--		do
--			create Result
--			check
--				do_not_call: false
--					-- Because this feature should be UNDEFINED and the
--					-- version from {EV_WIDGET} or {EV_MODEL} called.
--			end
--		end

	pointer_motion_actions: EV_POINTER_MOTION_ACTION_SEQUENCE
			-- Actions to be performed when screen pointer moves.
			-- Defined here as place-holder to be undefined (i.e. joined) to
			-- the version from {EV_WIDGET} or {EV_MODEL}.
			-- See index clause for information on pick-and-put.
		deferred
		end
--		do
--			create Result
--			check
--				do_not_call: false
--					-- Because this feature should be UNDEFINED and the
--					-- version from {EV_WIDGET} or {EV_MODEL} called.
--			end
--		end

	pick_actions: EV_PND_START_ACTION_SEQUENCE
			-- Actions to be performed when `pebble' is picked up.
			-- Defined here as place-holder to be undefined by some
			-- {EV_WIDGET} or {EV_MODEL}.
		deferred
		end
--		do
--			create Result
--			check
--				do_not_call: false
--					-- Because this feature should be UNDEFINED and the
--					-- version from {EV_WIDGET} or {EV_MODEL} called.
--			end
--		end

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

invariant

--	not_empty: target_imp /= Void

end
