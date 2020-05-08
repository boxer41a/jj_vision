note
	description: "[
		Binary nodes of an {S_TREE} used by {SPLIT_MANAGER}.
		The node contains a VIEW, but works specially for {SPLIT_AREA_VIEW}
		]"
	date: "17 Nov 07"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/s_tree_node.e $"
	date:		"$Date: 2015-11-03 12:26:31 -0800 (Tue, 03 Nov 2015) $"
	revision:	"$Revision: 24 $"

class
	S_TREE_NODE

inherit

	ANY
		redefine
--			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_view: like view)
			-- Create a node holding `a_view' in `view'.
		require
			view_exists: a_view /= Void
		do
			view := a_view
		ensure
			view_set: view = a_view
		end

feature -- Access

	view: VIEW
			-- The view in this node.
--		do
--			check attached view_imp as ii then
--				Result := ii
--			end
--		end

	first: like Current
			-- First child.
		do
			check attached first_imp as f then
				Result := f
			end
		end

	second: like Current
			-- Second child.
		do
			check attached second_imp as s then
				Result := s
			end
		end

	parent: like Current
			-- Parent of which Current is a child.
		do
			check attached parent_imp as p then
				Result := p
			end
		end

	other_node (a_node: like Current): detachable like Current
			-- The child of current which is not `a_node'.
		require
			node_exists: a_node /= Void
			has_node: has (a_node)
		do
			if a_node = first then
				Result := second
			else
				Result := first
			end
		ensure
			result_exists: Result /= Void
			result_is_child: Result.parent = Current
		end

	descendents: LINKED_SET [attached like Current]
			-- All the nodes descended from Current "post-order" (first, second, Current)
		do
			create Result.make
			if attached first_imp as f and attached second_imp as s then
				Result.merge (f.descendents)
				Result.merge (s.descendents)
			end
			Result.extend (Current)
		end

	internal_nodes: LINKED_SET [like Current]
			-- All the descendent nodes of Current which are not leaf (`is_empty') nodes
		do
			create Result.make
			if attached first_imp as f and attached second_imp as s then
				Result.merge (f.internal_nodes)
				Result.merge (s.internal_nodes)
				Result.extend (Current)
			end
		end

	leaf_nodes: LINKED_SET [like Current]
			-- All the descendent nodes which are leaf (`is_empty') nodes.
		do
			create Result.make
			if attached first_imp as f and attached second_imp as s then
				Result.merge (f.leaf_nodes)
				Result.merge (s.leaf_nodes)
			else
				Result.extend (Current)
			end
		end

feature -- Element change

	set_view (a_view: like view)
			-- Make Current hold `a_view'.
		require
			view_exists: a_view /= Void
		do
			view := a_view
		ensure
			view_set: view = a_view
		end

--	remove_view
--			-- Make sure `view' is Void
--		do
--			view_imp := Void
--		ensure
--			view_removed: view_imp = Void
--		end

	set_children (a_first, a_second: like Current)
			-- Change `first'.
		require
			first_exists: a_first /= Void
			second_exists: a_second /= Void
		do
			first_imp := a_first
			second_imp := a_second
			a_first.set_parent (Current)
			a_second.set_parent (Current)
		ensure
			first_set: first = a_first
			second_set: second = a_second
			first_parent_set: a_first.parent = Current
			second_parent_set: a_second.parent = Current
			is_full: is_full
		end

	set_first (a_first: like Current)
			-- Change `first'
		require
			first_exists: a_first /= Void
			is_full: is_full
		do
			first_imp := a_first
			first.set_parent (Current)
		ensure
			first_set: first = a_first
			first_parent_set: first.parent = Current
		end

	set_second (a_second: like Current)
			-- Change `second'
		require
			second_exists: a_second /= Void
			is_full: is_full
		do
			second_imp := a_second
			second.set_parent (Current)
		ensure
			second_set: second = a_second
			second_parent_set: second.parent = Current
		end

	remove_children
			-- Make sure current has no children.
		require
			is_full: is_full
		do
			if attached first_imp as f then
				f.remove_parent
			end
			if attached second_imp as s then
				s.remove_parent
			end
			first_imp := Void
			second_imp := Void
		ensure
			is_empty: is_empty
		end

feature -- Basic operations

	test_print (indent: INTEGER)
			-- Output for testing
		local
			i: INTEGER
		do
			from i := 1
			until i > indent
			loop
				io.put_string ("%T")
				i := i + 1
			end
			io.put_string ("view = ")
			if attached view as it then
				io.put_string (it.out)
			end
			io.new_line
			if attached first as f then
				f.test_print (indent + 1)
			end
			if attached second as s then
				s.test_print (indent + 1)
			end
		end


feature -- Status report

	is_split: BOOLEAN
			-- Does Current contain a node that has a
			-- {HORIZONTAL_SPLIT_VIEW} or a {VERTICAL_SPLIT_VIEW}?
		do
			Result := attached {HORIZONTAL_SPLIT_VIEW} view or
						attached {VERTICAL_SPLIT_VIEW} view
		end

	is_view: BOOLEAN
			-- Is this not a split area?
		do
			Result := not is_split
		end

	is_full: BOOLEAN
			-- Does Current have two children?
		do
			Result := first_imp /= Void and second_imp /= Void
		ensure
			definition: Result implies first_imp /= Void and second_imp /= Void
		end

	is_empty: BOOLEAN
			-- Does Current have zero children?
		do
			Result := first_imp = Void and second_imp = Void
		ensure
			definition: Result implies first_imp = Void and second_imp = Void
		end

	is_orphan: BOOLEAN
			-- Does Current has no parent?
		do
			Result := parent_imp = Void
		ensure
			definition: Result = (parent_imp = Void)
		end

feature -- Query

	is_child_of (a_node: like Current): BOOLEAN
			-- Is Current a child of `a_node'?
		require
			node_exists: a_node /= Void
		do
			Result := parent = a_node
		ensure
			definition: Result implies parent = a_node
		end

	has (a_node: like Current): BOOLEAN
			-- Is `a_node' a child of Current?
		require
			node_exists: a_node /= Void
		do
			Result := first = a_node or else second = a_node
		ensure
			definition: Result implies first = a_node or else second = a_node
		end

	is_first (a_node: like Current): BOOLEAN
			-- Is Current the first child of `a_node'?
		require
			node_exists: a_node /= Void
		do
			Result := a_node.first = Current
		ensure
			definition: Result implies a_node.first = Current
		end

	is_second (a_node: like Current): BOOLEAN
			-- Is Current the second child of `a_node'?
		require
			node_exists: a_node /= Void
		do
			Result := a_node.second = Current
		ensure
			definition: Result implies a_node.second = Current
		end

	is_sibling (a_node: like Current): BOOLEAN
			-- Is `a_node' a sibling of Current?  (I.e. is Current and `a_node'
			-- both children of the same node?
		require
			node_exists: a_node /= Void
		do
			Result := a_node.parent = parent
		ensure
			definition: Result implies a_node.parent = parent
		end

feature {S_TREE_NODE} -- Implementation

	set_parent (a_node: like parent)
			-- Make `a_node' the parent of Current.
		require
			node_exists: a_node /= Void
			has_child: a_node.has (Current)
		do
			parent_imp := a_node
		ensure
			parent_set: parent = a_node
		end

	remove_parent
			-- Make sure current has no parent.
			-- Requires the parent to already have no children
		require
			not_is_orphan: not is_orphan
			not_has_child: parent.is_empty
		do
			parent_imp := Void
		ensure
			is_orphan: is_orphan
		end

	first_imp: detachable like Current
			-- Detachable implementation of `first' for Void safety

	second_imp: detachable like Current
			-- Detachable implementation of `second' for Void safety

	parent_imp: detachable like Current
			-- Detachable implementation of `parent' for Void safety

invariant

	zero_or_two_children: is_full or is_empty

end
