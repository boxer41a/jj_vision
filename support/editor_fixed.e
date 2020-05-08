note
	description: "[
		An EV_FIXED which can only hold {CONTROL}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/editor_fixed.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"
	
class
	EDITOR_FIXED

inherit

	EV_FIXED
		redefine
			initialize
--			item
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
			-- Initialize `Current'.
		do
			Precursor {EV_FIXED}
			set_actions
		end

	set_actions
			-- Add actions to current
		do

		end

feature -- Access

--	item: CONTROL is
--			-- Redefined to allow only CONTROLs to be placed in current
--		do
--			Result ?= Precursor {EV_FIXED}
--		ensure then
--			valid_result: Result /= Void
--		end

end
