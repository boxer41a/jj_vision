note
	description: "[
		Common ancestor to classes used to persist the state 
		of each {VIEW} in the system
		]"
	date: "15 Mar 08"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/state.e $"
	date:		"$Date: 2012-05-31 14:05:35 -0400 (Thu, 31 May 2012) $"
	revision:	"$Revision: 10 $"

deferred class
	STATE

--inherit
--	ID_FACILITIES


feature {NONE} -- Initialization

	make (a_object: ANY)
			-- Create a structure to save the state of an object.
			-- This is really for persisting the state of EV_WIDGETs or objects
			-- that reference EV_WIDGETs, because EV_WIDGETs have no persistent
			-- image.
		require
			object_exists: a_object /= Void
		do
		end

feature -- Access

	frozen view: like new_view
			-- The object initialized with the attributes of Current.
			-- Redefine to add new attributes after calling Precursor.
		do
			if attached view_imp as v then
				Result := v
			else
				view_imp := new_view
				check attached view_imp as v then
					Result := v
				end
				set_view_attributes
			end
--			set_view_attributes
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Implementation

	set_view_attributes
			-- Set up the view created from Current
		do
		end

	application: JJ_APPLICATION
			-- Handle to the current application
		once
			check attached {JJ_APPLICATION} (create {EV_ENVIRONMENT}).application as a then
				Result := a
			end
		end

	new_view: ANY
			-- Create the `view_imp'
		require
			not_already_called: not attached view_imp
		deferred
		end

	view_imp: detachable like new_view
			-- Used to create the view only once

end
