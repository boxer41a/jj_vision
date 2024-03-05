note
	description: "[
		Used to store the appearance of a {VIEW}
		This class and descendants are used to capture some 
		attributes of EV_WIDGETs so that the [appearance of]
		the widgets can be persisted and restored.
		]"
	date: "13 Oct 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/view_state.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	VIEW_STATE

inherit

	STATE
		redefine
			make,
			set_view_attributes
		end

create
	make

feature {NONE} -- Initialization

	make (a_view: VIEW)
			-- Initialize `Current'.
		local
			lin: LINEAR [ANY]
			a: ANY
--			ds: DATASTORE
		do
			target := a_view.target
--			ds := Application.persistence_manager.user_datastore
--			a := a_view.target
--			if a /= Void and then ds.is_stored (a) then
--				target_id := Application.persistence_manager.user_datastore.object_id (a)
--			else
--				target_id := Void_id
--			end
--			create target_id_set.make
--			lin := a_view.objects
--			from lin.start
--			until lin.exhausted
--			loop
--				a := lin.item
--				if a /= Void and then ds.is_stored (a)then
--					target_id_set.extend (Application.persistence_manager.user_datastore.object_id (a))
--				end
--				lin.forth
--			end
-- FIX ME!
--			split_manager_state := a_view.split_manager.state
		end

feature {NONE} -- Access

-- FIX ME!
--	split_manager_state: SPLIT_MANAGER_STATE
			-- Holds the state of the `split_manager'.

	set_view_attributes
			-- Set up the view
		do
-- Fix me!
--			view.set_split_manager (split_manager_state.view)
		end

feature {NONE} -- Implementation

	target: ANY
			-- The object that was displayed in the {VIEW} from
			-- which this state was made

	target_anchor: ANY
			-- Type anchor for the creation of a new target of the correct type
			-- and to check that retrieval of an object from a DATASTORE is of
			-- the correct type.
			-- Declared as once to prevent adding an attribute to Current
			-- Redefine covariantly descendents of VIEW to correspond to the type
			-- of the `target' from the redefined VIEW.
		do
			check
				do_not_call: False then
			end
		end

	new_view: VIEW
			-- Create a new VIEW
			-- This must be redefined to remove the check
		do
			check
				must_redefine: False then
					-- because do not want this class to be deferred, but
					-- {VIEW} is not an effected class and cannot be created
				end
		end

end
