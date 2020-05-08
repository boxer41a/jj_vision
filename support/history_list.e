note
	description: "[
		A list of {VIEWABLE} 
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/history_list.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class

--	HISTORY_LIST [G -> HISTORY_ITEM]
		-- Generics would not work because the assignment attemts in `item'
		-- and `selected_item' can not have a assignment target which is
		-- a generic type because the type could be expanded.

	HISTORY_LIST

inherit

	EV_LIST
		redefine
--			item,
--			selected_item
		end

create
	default_create

feature -- Access

--	item: HISTORY_ITEM is
--			-- Redefined to lock in the type
--		do
--			Result ?= Precursor {EV_LIST}
--		end

--	selected_item: like item is
--			-- Currently selected item.
--			-- Topmost selected item if multiple items are selected.
--			-- Redefined to lock in type
--		do
--			Result ?= Precursor {EV_LIST}
--		end

end
