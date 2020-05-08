note
	description: "[
		A binary-like tree for holding "siblings" or "splits" for use by
		{SPLIT_MANAGER}.  The tree manages the placement of exactly two child
		views into a node of the tree.
		]"
	date: "17 Nov 07"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/s_tree.e $"
	date:		"$Date: 2012-05-19 11:28:28 -0400 (Sat, 19 May 2012) $"
	revision:	"$Revision: 9 $"

deferred class
	S_TREE

inherit

	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Create an empty tree.
		do
		end

	make (a_view: like root_view)
			-- Make a new tree whose `root' node contains `a_view'.
		require
			view_exists: a_view /= Void
		do
			create root.make (a_view)
			last_node := root
		end

feature -- Access

	root: detachable S_TREE_NODE
		-- The root of the tree.

	root_view: VIEW
			-- The view in the root node.
		require
			not_empty: not is_empty
		do
			check attached root as r then
				Result := r.view
			end
		ensure
			result_exists: Result /= Void
		end

	last_view: like root_view
			-- The `view' in the parent node created when two new nodes are
			-- added with a call to `extend'.
		require
			not_empty: not is_empty
		do
			check attached last_node as ln then
				Result := ln.view
			end
		end

	descendents: LINKED_SET [attached like root]
			-- All the nodes descended from `root' "post-order" (first, second, Current)
		do
			if attached root as r then
				Result := r.descendents
			else
				create Result.make
			end
		end

	internal_nodes: LINKED_SET [attached like root]
			-- All the descendent nodes of Current which are not leaf (`is_empty') nodes
		do
			if attached root as r then
				Result := r.internal_nodes
			else
				create Result.make
			end
		end

	leaf_nodes: LINKED_SET [attached like root]
			-- All the descendent nodes which are leaf (`is_empty') nodes.
		do
			if attached root as r then
				Result := r.leaf_nodes
			else
				create Result.make
			end
		end

feature -- Element change

	set_root_view (a_view: like root_view)
			-- Change the `view' of `root'.
		require
			view_exists: a_view /= Void
			not_empty: not is_empty
		do
			check attached root as r then
				r.set_view (a_view)
			end
		end

	set_root (a_node: like root)
			-- Set `root' to `a_root'.
		require
			node_exists: a_node /= Void
		do
			root := a_node
		end

feature -- Measurement

	count: INTEGER
			-- The number of nodes in the tree.
		do
			if attached root as r then
				Result := r.descendents.count
			end
		end

	leaf_count: INTEGER
			-- The number of leaf nodes under `root'.
		require
			not_empty: not is_empty
		do
			check attached root as r then
				Result := r.leaf_nodes.count
			end
		end

feature -- Basic operations

--	test_print is
--			--
--		do
--			root.test_print (0)
--			io.new_line
--			io.new_line
--		end

	extend (a_view: VIEW)
			-- Add `a_view' as a sibling to the previously added view.
		require
			view_exists: a_view /= Void
			not_has_view: not has (a_view)
		local
			p, n, internal_n: like root
		do
			create n.make (a_view)
			if attached last_node as ln then
				if ln.is_orphan then
					create p.make (new_view)
					p.set_children (ln, n)
					root := p
				else
					create internal_n.make (new_view)
					internal_n.set_children (ln.parent, n)
					root := internal_n
				end
			else
				root := n
			end
--			if last_node = Void then
--					-- Add as root
--				root := n
--			elseif last_node.parent = Void then
--				create p.make (new_view)
--				p.set_children (last_node, n)
--				root := p
--			else
--				check attached last_node.parent as par then
--					create internal_n.make (new_view)
--					internal_n.set_children (par, n)
--					root := internal_n
--				end
--			end
			last_node := n
		ensure
			has_view: has (a_view)
		end

	extend_siblings (a_first, a_second: VIEW)
			-- Searching from `root', find the nodes containing `a_first', and/or
			-- `a_second' or, if not finding them, create new nodes containing
			-- `a_first', and `a_second' and make them children of a new node.
			--  Set `last_node' to the new node.
		require
			first_exists: a_first /= Void
			second_exists: a_second /= Void
			not_same: a_first /= a_second
			has_both_only_if_siblings: (has (a_first) and has (a_second)) implies is_siblings (a_first, a_second)
		local
			n1, n2: like root
			new_internal_n: like root
			n: like root
		do
			if has (a_first) and has (a_second)then
				n1 := corresponding_node (a_first)
				n2 := corresponding_node (a_second)
				check
					is_siblings: is_siblings (a_first, a_second)
						-- Because of precondition "has_both_only_if_siblings"
				end
					-- The nodes are siblings already in tree so simply change the
					-- `view' contained in the `parent' node of `n1' and `n2' to
					-- ensure it matches the type set by `new_view'.
				check
					attached n1.parent as p then
						p.set_view (new_view)
						last_node := p
				end
			elseif has (a_first) or has (a_second) then
				create new_internal_n.make (new_view)
				if has (a_first) then
					check
						not_has_second: not has (a_second)
							-- because of previous if statement.
					end
					n1 := corresponding_node (a_first)
					create n2.make (a_second)
				else
					check
						has_second: has (a_second)
							-- because of previous if statement.
					end
					n2 := corresponding_node (a_second)
					create n1.make (a_first)
				end
				if n1.is_orphan then
					check
						is_root: n1 = root
							-- Only node without a parent should be the root.
					end
					root := new_internal_n
					last_node := new_internal_n
				else
					check attached n1.parent as p then
						check attached p.other_node (n1) as on then
							if n1.is_first (p) then
								p.set_children (new_internal_n, on)
							else
								p.set_children (on, new_internal_n)
							end
						end
					end
				end
				new_internal_n.set_children (n1, n2)
			else		-- neither `a_first' or `a_second' is already in tree.
				create new_internal_n.make (new_view)
				create n1.make (a_first)
				create n2.make (a_second)
				new_internal_n.set_children (n1, n2)
				last_node := new_internal_n
				if attached root as r then
					n := r
					create root.make (new_view)
						-- Why is this check required?  It will not compile without it.
					check attached root as r2 then
						r2.set_children (n, new_internal_n)
					end
				else
					root := new_internal_n
				end
			end
		ensure
			root_exists: root /= Void
--			new_root: root /= old root
			root_is_full: attached root as r and then r.is_full
--			root_has_first_view: root.first.view = a_first
--			root_has_second_view: root.second.view = a_second
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Is the tree empty?
		do
			Result := root = Void
		end

	is_adding_vertically: BOOLEAN
			-- Are views to be inserted into a {VERTICAL_SPLIT_VIEW}?
			--  (Instead of a {HORIZONTAL_SPLIT_VIEW}

feature -- Status setting

	set_vertical
			-- Make new veiws be a {VERTICAL_SPLIT_VIEW}
		do
			is_adding_vertically := True
		end

	set_horizontal
			-- Make new view be a {HORIZONTAL_SPLIT_VIEW}
		do
			is_adding_vertically := False
		end

feature -- Query

	has (a_view: VIEW): BOOLEAN
			-- Does Current have a node containing `a_view'?
		require
			view_exists: a_view /= Void
		local
			s: like descendents
		do
			if attached root as r then
				s := r.descendents
				from s.start
				until Result or else s.exhausted
				loop
					Result := s.item.view = a_view
					s.forth
				end
			end
		end

	has_node (a_node: like root): BOOLEAN
			-- Does the tree contain `a_node'?
		require
			node_exists: a_node /= Void
		local
			s: like descendents
		do
			check attached root as r then
				s := r.descendents
				from s.start
				until Result or else s.exhausted
				loop
					Result := s.item = a_node
					s.forth
				end
			end
		end

	corresponding_node (a_view: VIEW): attached like root
			-- The node containing `a_view'.
		require
			node_exists: a_view /= Void
			has_view: has (a_view)
		local
			found: BOOLEAN
			s: LINKED_SET [attached like root]
			n: like root
		do
			check attached root as r then
				n := r
				s := r.descendents
				from s.start
				until found or else s.exhausted
				loop
					n := s.item
					if n.view = a_view then
						found := True
					end
					s.forth
				end
				Result := n
			end
		end

	is_siblings (a_first, a_second: VIEW): BOOLEAN
			-- Are `a_first' and `a_second' views of nodes which are children of a common parent?
		require
			first_exists: a_first /= Void
			second_exists: a_second /= Void
		local
			n1, n2: like root
		do
			if has (a_first) and has (a_second) then
				n1 := corresponding_node (a_first)
				n2 := corresponding_node (a_second)
				Result := n1.parent = n2.parent
			end
		end

feature {NONE} -- Implementation

	last_node: like root
			-- The last node created while building the tree.  To give
			-- access to the last view.

	new_view: like root_view
			-- Create a new `view'.  Used to initialize a new root node.
		do
			if is_adding_vertically then
				create {VERTICAL_SPLIT_VIEW} Result
			else
				create {HORIZONTAL_SPLIT_VIEW} Result
			end
		end

	has_invalid_node: BOOLEAN
			-- Does Current contain a node whose `view' is Void
		local
			s: like descendents
		do
			if attached root as r then
				s := r.descendents
				from s.start
				until Result or else s.exhausted
				loop
					Result := attached s.item as n and then n.view = Void
					s.forth
				end
			end
		end

invariant

	all_nodes_have_an_view: root /= Void implies not has_invalid_node

end
