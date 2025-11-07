note
	description: "[
		Support class used by {VIEW} to associate a target object with
		one or more {VIEW} objects.
		]"
	author:    "Jimmy J. Johnson"
	date:      "11/11/23"
	copyright: "Copyright (c) 2023, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VIEW_MANAGER

inherit

	ANY
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Create an instance
		do
			create views_table.make (100)
			create views_list.make
		end

feature -- Access

	linear (a_object: ANY): LINEAR [VIEW]
			-- List of views in which `a_object' is displayed.  The
			-- resulting list could be empty.
		local
			tup: like views_list.item
			found: BOOLEAN
		do
				-- Assume not found, so result is empty (Void-safety)
			Result := (create {LINKED_SET [VIEW]}.make).linear_representation
			if attached {HASHABLE} a_object as h then
					-- Search the hash table
				if views_table.has (h) then
					Result := views_table.definite_item (h).linear_representation
					found := true
				end
			else
					-- Must do sequential search of `views_list'
				from views_list.start
				until found or else views_list.after
				loop
					tup := views_list.item
					if tup.object = a_object then
						Result := tup.views.linear_representation
						found := true
					end
					views_list.forth
				end
			end
		end

	linear_with_set (a_set: LINEAR [ANY]): LINEAR [VIEW]
			-- List of views in which any of the objects in `a_set'
			-- is displayed.
		local
			r: LINKED_SET [VIEW]
		do
			create r.make
			from a_set.start
			until a_set.after
			loop
				r.merge (linear (a_set.item))
				a_set.forth
			end
			Result := r.linear_representation
		end

	linear_representation: LINEAR [VIEW]
			-- Linear representation of all the views in the system
		local
			s: LINKED_SET [VIEW]
			r: LINKED_SET [VIEW]
		do
			create r.make
				-- Get views from the table
			from views_table.start
			until views_table.after
			loop
				s := views_table.item_for_iteration
				r.merge (s)
				views_table.forth
			end
				-- Get views from the set
			from views_list.start
			until views_list.after
			loop
				s := views_list.item.views
				r.merge (s)
				views_list.forth
			end
			Result := r.linear_representation
		end

feature -- Element change

	extend (a_view: VIEW)
			-- Add `a_view' to the list of tracked view/object pairings,
			-- associating `a_view' with its `target' for easy lookup
			-- by `target'.
			-- Note:  the `target' may already be associated with some
			-- other view, which is okay.
		require
			not_has_view: not has_view (a_view)
		local
			set: like views_table.definite_item
			tup: like views_list.item
			found: BOOLEAN
		do
				-- Put in table if {HASHABLE}
			if attached {HASHABLE} a_view.target as h then
				if views_table.has (h) then
						-- add `a_view' to an existing list
					set := views_table.definite_item (h)
					set.extend (a_view)
				else
						-- make new list containing Current and add it to the table
					create set.make
					set.extend (a_view)
					views_table.extend (set, h)
				end
			else
					-- Not a {HASHABLE} so add to the sequential list
				from views_list.start
				until found or else views_list.after
				loop
					tup := views_list.item
					if tup.object = a_view.target then
						set := tup.views
						found := true
					end
					views_list.forth
				end
				if found then
						-- add to the existing list
					check attached set as s then
						s.extend (a_view)
					end
				else
						-- add to a new list
					create set.make
					set.extend (a_view)
					views_list.extend ([set, a_view.target])
				end
			end
		ensure
			has_view: has_view (a_view)
			has: has (a_view.target)
			is_in_list: linear (a_view.target).has (a_view)
		end

	prune (a_view: VIEW)
			-- Ensure `a_view' is not associated with any target in Current
		require
			has_view: has_view (a_view)
		local
			set: like views_table.definite_item
			tup: like views_list.item
			found: BOOLEAN
		do
			if attached {HASHABLE} a_view.target as h then
				set := views_table.definite_item (h)
				set.prune (a_view)
				if set.is_empty then
					views_table.remove (h)
				end
			else
					-- not {HASHABLE} so remove from `views_list'
				from views_list.start
				until found or else views_list.after
				loop
					tup := views_list.item
					if tup.object = a_view.target then
						found := true
						set := tup.views
						check
							has_view: set.has (a_view)
								-- because of precondition and `a_view' must be
								-- in the set keyed to its target
						end
						set.prune (a_view)
					end
					views_list.forth
				end
			end
		ensure
			not_has_view: not has_view (a_view)
		end

feature -- Query

	has (a_object: ANY): BOOLEAN
			-- Is there a list of views (one or more views)
			-- associated with `a_object'?
		local
			tup: like views_list.item
		do
				-- Search `views_table' first
			if attached {HASHABLE} a_object as h then
				Result := views_table.has (h)
			else
					-- Must do sequential search of `views_list'
				from views_list.start
				until Result or else views_list.after
				loop
					tup := views_list.item
					Result := tup.object = a_object
					views_list.forth
				end
			end
		end

	has_view (a_view: VIEW): BOOLEAN
			-- Does Current contain `a_view'?
		local
			set: like views_table.item_for_iteration
			tup: like views_list.item
			v: VIEW
		do
				-- Must do a sequencial search of both structures.  It may be
				-- possible to have `a_view' previously associated with some
				-- other `target'
			from views_table.start
			until Result or else views_table.after
			loop
				set := views_table.item_for_iteration
				from set.start
				until Result or else set.after
				loop
					v := set.item
					Result := v = a_view
					set.forth
				end
				views_table.forth
			end
				-- Now check the list
			from views_list.start
			until views_list.after
			loop
				tup := views_list.item
				set := tup.views
				from set.start
				until Result or else set.after
				loop
					v := set.item
					Result := v = a_view
					set.forth
				end
				views_list.forth
			end
		end

feature -- Basic operations

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
			lin := linear (a_target)
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
				prune (marks.item)
				marks.forth
			end
		end

	notify_views_with_set (a_set: LINEAR [ANY])
			-- Notify the views which contain any of the objects in `a_set'.
			-- This also cleans any "destroyed" views from the `views' set.
		require
			set_exists: a_set /= Void
		local
			lin: LINEAR [VIEW]
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
		do
			create marks.make
			lin := linear_with_set (a_set)
			from lin.start
			until lin.after
			loop
				v := lin.item
				if v.is_destroyed then
					marks.extend (v)
				end
				v.target_changed_operations
				lin.forth
			end
				-- Clean out any views that are no longer usable.
			from marks.start
			until marks.exhausted
			loop
				prune (marks.item)
				marks.forth
			end
		end

	notify_parents (a_target: ANY)
			-- Inform the parent-views of any views that target
			-- `a_target' that `a_target' has changed.
		local
			lin: LINEAR [VIEW]
			marks: LINKED_SET [VIEW]	-- Views marked for removal.
			v: VIEW
			pv: VIEW
		do
			create marks.make
			lin := linear (a_target)
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
				prune (marks.item)
				marks.forth
			end
		end

	notify_parents_with_set (a_set: LINKED_SET [ANY])
			-- Inform the parent-views of any views that target
			-- any of the items in `a_set' that the view's target
			-- has changed.
		local
			t: ANY
			v_set: LINKED_SET [ANY]
		do
			create v_set.make
			from a_set.start
			until a_set.exhausted
			loop
				t := a_set.item
					-- Notify each parent of each item in `a_set',
					-- but only once per item.
				if not v_set.has (t) then
					notify_parents (t)
					v_set.extend (t)
				end
				a_set.forth
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
			lin := linear (a_target)
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
				prune (marks.item)
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
			lin := linear_with_set (a_set)
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
				prune (marks.item)
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
			lin := linear_representation
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
				prune (marks.item)
				marks.forth
			end
		end

feature {NONE} -- Contract support

	has_bad_table_association: BOOLEAN
			-- Is any {VIEW} in the `views_table' NOT associated with the correct
			-- key?  (I.e. is there a {VIEW} indexed by a key, where that key is
			-- NOT the `target' of the associated {VIEW}?)
		local
			set: like views_table.item_for_iteration
			v: VIEW
			k: ANY
		do
			from views_table.start
			until Result or else views_table.after
			loop
				k := views_table.key_for_iteration
				set := views_table.item_for_iteration
				from set.start
				until Result or else set.after
				loop
					v := set.item
					Result := v.target /= k
					if Result then
						do_nothing
					end
					set.forth
				end
				views_table.forth
			end
		end

	has_bad_list_association: BOOLEAN
			-- Is any {VIEW} in the `views_list' NOT associated with the correct
			-- key?  (I.e. is there a {VIEW} indexed by a key, where that key is
			-- NOT the `target' of the associated {VIEW}?)
		local
			set: like views_table.item_for_iteration
			tup: like views_list.item
			v: VIEW
		do
			from views_list.start
			until Result or else views_list.after
			loop
				tup := views_list.item
				set := tup.views
				from set.start
				until Result or else set.after
				loop
					v := set.item
					Result := v.target /= tup.object
					set.forth
				end
				views_list.forth
			end
		end

feature {NONE} -- Implementation

	views_table: HASH_TABLE [LINKED_SET [VIEW], HASHABLE]
			-- Lists of views indexed by an object where that object is a
			-- {HASHABLE}

	views_list: LINKED_LIST [TUPLE [views: LINKED_SET [VIEW]; object: ANY]]
			-- Lists of views indexed by an object.  This list must be sequentially
			-- serched for the list associated with a particular object


invariant

--	not_has_bad_table_association: not has_bad_table_association
--	not_has_bad_list_association: not has_bad_list_association

end
