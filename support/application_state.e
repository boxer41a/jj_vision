note
	description: "[
		Used by {JJ_APPLICATION} to persist "state" attributes (number 
		of windows, etc.) of the application
		]"
	date: "12 Oct 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/application_state.e $"
	date:		"$Date: 2012-05-31 14:05:35 -0400 (Thu, 31 May 2012) $"
	revision:	"$Revision: 10 $"

class
	APPLICATION_STATE

inherit

	SHARED
		redefine
			default_create
		end

	STATE
		redefine
			default_create,
			make,
			set_view_attributes
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	default_create
			-- Initialize `Current' using the currently running application.
		local
			wins: LINKED_LIST [JJ_MAIN_WINDOW]
			w: JJ_MAIN_WINDOW
			ws: MAIN_WINDOW_STATE
		do
--			target_id := application.persistence_manager.user_datastore.object_id (application.target)
			create window_states.make
			wins := main_windows
			from wins.start
			until wins.exhausted
			loop
				w := wins.item
				ws := w.state
				window_states.extend (ws)
				wins.forth
			end
		end

feature -- Initialization

	make (a_application: JJ_APPLICATION)
			-- Initialize `Current'.
		do
			default_create
		end

feature -- Access

	set_view_attributes
			-- Initialize the windows of the applicatin from the attributes of Current.
		local
			ws: MAIN_WINDOW_STATE
			fw, w: detachable JJ_MAIN_WINDOW
		do
			check
				at_least_one_main_window: window_states.count >= 1
					-- Because to save the state an application must have run creating
					-- at least one window in the process.
			end

			if main_windows.count >= 1 then
					-- Close any open windows except one; keep one so application doesn't exit.
					-- There may be zero windows if it is starting from a previous state.
				from main_windows.start
				until main_windows.count <= 1
				loop
					main_windows.item.on_close_window
				end
					-- Hold on to the remaining window
				fw := main_windows.first
			end
				-- Force creation of new windows from the state.
			from window_states.start
			until window_states.exhausted
			loop
				ws := window_states.item
					-- Force creation of a window by calling `widget'; no need
					-- to do anything with `w'.
				w := ws.view
				w.show
				window_states.forth
			end
				-- Destroy the old, last remaining window.
			if fw /= Void then
				fw.on_close_window
			end
		end

feature {NONE} -- Implementation

--	system: JJ_SYSTEM
--	target_id: OBJECT_ID
			-- The object_id of the data this application will manipulate.

	window_states: LINKED_LIST [MAIN_WINDOW_STATE]
			-- The list of windows used by the application.

	new_view: JJ_APPLICATION
			-- Redefined to return the current application; not create a new one.
		do
			Result := application
		end

end
