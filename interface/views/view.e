note
	description: "[
		Used as common ancestor to all "windows" in a system built using the 
		"jj_vision" cluster.  It provides a way through feature `draw_views'
		for updating all the views which contain the argument to that feature. 
		Objects which this view will be responsible for displaying are contained in
		feature `target_set'.  The view can force a redraw of all other views
		containing a certain temp_object (preferably a temp_object which it contains) by using
		feature `draw_views' and passing the changed temp_object.  Alternatively, the view
		can force the redraw of views containing any of several objects by passing a set
		of changed objects to feature `draw_views_with_set'.  This class undefines 
		features from ANY with the intent that this class will be ancestor along with
		some effected EV_WIDGET which will effect those features.
		NOTE:  LINKED_SET was used as a client for feature `target_set'; using
		inheritance causes too many name clashes with EV_WIDGET.
		NOTE:  Views which are `is_destroyed' are removed from the global `views' set
		in feature `draw_views'.  This elliminated the need to force descendents to
		redefine `destroy' and `is_destroyed'.  It is simpler this way.
		]"
	instructions: "[
		Must redefine `draw'.
--		When redefining `initialize' call precursor of VIEW after the precursor for
--		the EV_WIDGET because of pre and post-conditions involving `is_initialized'.
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

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation
			-- bridge pattern.
		do
			create target_set.make
			create pixmap.make_with_pixel_buffer (Icon_new_class_color_buffer)
		end

	initialize
			-- Initialize the view and insert it into a global list of views.
		require
			view_not_initialized: not is_view_initialized
		do
			views.extend (Current)
			add_actions
			is_view_initialized := True
		ensure
			initialized: is_view_initialized
		end

	add_actions
			-- Add any actions to Current.
			-- Called by `initialize'.
		require
--			view_not_initialized: not is_view_initialized
		do
			is_view_initialized := True
		end

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

	target_item: ANY
			-- Current target in the set.
		require
			readable: not is_view_off
		do
			Result := target_set.item
		ensure
			valid_result: Result /= Void
		end

	objects: LINEAR [ANY]
			-- A copy of the list of targets stored in this view.
		do
			target_set.start
			Result := target_set.duplicate (target_set.count)
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
			-- Change the value of `target' and add it to the `target_set' (the set
			-- of objects contained in this view.  The old target is removed from
			-- the set.
			-- This feature can be used as a pattern if a descendant wants to give
			-- special treatment to a single target.
		do
			if target_imp /= Void then
				target_set.prune (target)
			end
			target_set.extend (a_target)
			target_imp := a_target
		ensure
			target_assigned: target = a_target
			contains_target: a_target /= Void implies target_set.has (a_target)
		end

	add_target (a_target: like target)
			-- Add `a_target' to the list of items in this view and make
			-- `a_target' the current `target'.  Use this feature
			-- for views which require more objects than simply a `target' when
			-- the other objects do not need special handling.  (See `set_target'
			-- for pattern usage if the other objects need special handling.)
		require
			target_exists: a_target /= Void
		do
			target_set.extend (a_target)
			target_imp := a_target
		ensure
			has_target: target_set.has (a_target)
			target_assiged: target = a_target
		end

	prune_target (a_target: like target)
			-- Remove `a_object' from the view.
			-- If `a_target' was the previous `target' then make `target'
			-- become the first item in the set of targets or Void if the
			-- set is empty.
		require
			target_exists: a_target /= Void
		do
			target_set.prune (a_target)
			if target = a_target then
				if target_set.is_empty then
					target_imp := Void
				else
					check attached {like target} target_set.first as t then
						target_imp := t
					end
				end
			end
		ensure
			target_removed: not has_target (a_target)
			target_voided_if_same: a_target = old target implies target = Void
			target_unchanded_if_not_same: a_target /= old target implies target = old target
		end

	remove_all_targets
			-- Remove all the objects from this view.
		do
			target_set.wipe_out
			target_imp := Void
		ensure
			has_no_targets: target_set.is_empty
			target_voided: target = Void
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
			-- This also cleans any "destroyed" views from the `views' set.
		require
			target_exists: a_target /= Void
		local
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
		do
			create marks.make
			from views.start
			until views.exhausted
			loop
				v := views.item
				if v.is_destroyed then
					marks.extend (v)
				elseif not v.is_draw_disabled and then
						v.has_target (a_target) then
					v.draw
				end
				views.forth
			end
			from marks.start
			until marks.exhausted
			loop
				views.prune (marks.item)
				marks.forth
			end
		end

	draw_views_with_set (a_set: LINEAR [ANY])
			-- Draw the views which contain any of the objects in `a_set'.
			-- This also cleans any "destroyed" views from the `views' set.
		require
			set_exists: a_set /= Void
		local
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
		do
			create marks.make
			from views.start
			until views.exhausted
			loop
				v := views.item
				if v.is_destroyed then
					marks.extend (v)
				elseif not v.is_draw_disabled then
					from a_set.start
					until a_set.exhausted
					loop
						if v.has_target (a_set.item) then
							v.draw
						end
						a_set.forth
					end
				end
				views.forth
			end
			from marks.start
			until marks.exhausted
			loop
				views.prune (marks.item)
				marks.forth
			end
		end

	draw_all_views
			-- Draw *all* the views in the system.
			-- Also cleans any "destroyed" views for the `views' set.
		local
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
		do
			create marks.make
			from views.start
			until views.exhausted
			loop
				v := views.item
				if v.is_destroyed then
					marks.extend (v)
				elseif not v.is_draw_disabled then
					v.draw
				end
				views.forth
			end
			from marks.start
			until marks.exhausted
			loop
				views.prune (marks.item)
				marks.forth
			end
		end

feature -- Status report

	is_view_initialized: BOOLEAN
			-- Has the view been set up?

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
			Result := target_set.is_empty
		ensure
			valid_result: Result implies target_set.is_empty
		end

	is_view_off: BOOLEAN
		do
			Result := target_set.off
		end

	is_view_before: BOOLEAN
		do
			Result := target_set.before
		end

	is_view_after: BOOLEAN
		do
			Result := target_set.after
		end

	is_view_exhausted: BOOLEAN
		do
			Result := target_set.exhausted
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

	has_target (a_target: like target_item): BOOLEAN
		do
			Result := target_set.has (a_target)
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

feature -- Cursor movement

	targets_start
		do
			target_set.start
		end

	targets_forth
		require
			not_after: not is_view_after
		do
			target_set.forth
		end

	targets_back
		require
			not_before: not is_view_before
		do
			target_set.back
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

	target_set: LINKED_SET [ANY]
			-- Objects which this view is to display.

	views: LINKED_SET [VIEW]
			-- Global set to hold all the VIEWs in a system.
		once
			create Result.make
		end

invariant

	target_set_exists: target_set /= Void
	contains_target: target_imp /= Void implies target_set.has (target)

end
