note
	description: "[
		Root class for an application built using the "jj_vision" classes
		]"
	date: "19 Jul 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	date:		"$Date: 2015-10-24 07:32:40 -0700 (Sat, 24 Oct 2015) $"
	revision:	"$Revision: 23 $"

class
	JJ_APPLICATION

inherit

	SHARED
		export
			{NONE}
				all
--			{ANY}
--				persistence_manager
		undefine
			default_create,
			copy
		end

	EV_APPLICATION
		redefine
			destroy
		end

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch
			-- Initialize and launch application
--		local
--			l_app: EV_APPLICATION
		do
--				-- The use of `l_app' instead of inheritance is the style
--				-- used by the wizard in version 23.09.
--			create l_app
--			prepare
--				-- The next instruction launches GUI message processing.
--				-- It should be the last instruction of a creation procedure
--				-- that initializes GUI objects. Any other processing should
--				-- be done either by agents associated with GUI elements
--				-- or in a separate processor.
--			l_app.launch
--				-- No code should appear here,
--				-- otherwise GUI message processing will be stuck in SCOOP mode.
			default_create
			prepare
			launch
		end

	prepare
			-- Prepare the application by either loading it from a previous
			-- execution or create a new one if an old one doesn't exist.
		local
			w: like first_window
		do
--			initialize_directories
--			rebuild_application
			if not is_application_loaded then
				create w
				w.show
			end
		end

	destroy
			-- Save the state of all main_windows and end the application.
		do
--			save_system_state
			Precursor {EV_APPLICATION}
		end

	initialize_directories
			-- Set up the datastores for the system info.
		local
			d: DIRECTORY
		do
			create d.make (Default_data_path.name)
			if not d.exists then
				d.create_dir
			end
			create d.make (Default_settings_path.name)
			if not d.exists then
				d.create_dir
			end
		end

feature -- Access

	frozen first_window: like window_anchor
			-- Anchor to describe the type of the windows in the program.
		require
			has_at_least_one_window: has_windows
		do
			check attached {like window_anchor} main_windows.first as w then
				Result := w
			end
		ensure
			result_exists: Result /= Void
		end

--	command_manager: COMMAND_MANAGER is
--			-- Manages the COMMAND's called by the application to allow undo/redo capabilities.
--		once
--			create Result
--		end

	application_state: APPLICATION_STATE
			-- The state of the application.
		do
			create Result
		end

feature -- Status report

	has_windows: BOOLEAN
			-- Does at least one window exist in the application?
		do
			Result := not main_windows.is_empty
		end

feature -- Basic operations

	rebuild_application
			-- Rebuild the windows as they were on the last application exit.
		local
			f: RAW_FILE
			a: ANY
		do
				-- Attempt to read the `application_state' from the disk in order
				-- to begin this execution where the last one left off.
			create f.make (merged_file_name (Default_settings_path.name.as_string_8, "Application_State"))
			if f.exists and then f.is_readable then
				f.open_read
				if f.is_readable then
					if attached {like application_state} f.retrieved as app_state then
							-- Force a call to `widget' causing the creation of new windows.
						a := app_state.view
						is_application_loaded := True
					end
				end
			end
		end

	save_system_state
			-- Save the state of the system for restoration on next execution.
		local
			dn: STRING_32
			fn: STRING
			d: DIRECTORY
			f: RAW_FILE
		do
			dn := Default_settings_path.name
			create d.make (dn)
			if not d.exists then
				d.recursive_create_dir
			end
			fn := merged_file_name (Default_settings_path.name.as_string_8, "Application_State")
--			fn := "Application_state"
			create f.make (fn)
			if f.exists then
				f.wipe_out
--			else	
--				f.create_read_write
			end
			f.create_read_write
			f.general_store (application_state)
			f.close
		end

feature {NONE} -- Implementation

	is_application_loaded: BOOLEAN
			-- Was the last application state retrieved from a persistent file and
			-- now ready to be used to initialize the application?
			-- Set by `load_application_state'.

	Default_application_state_name: STRING = "Application State"
			-- To be used as file name of file containing the `state'.

feature {NONE} -- Implementation (anchors)

	window_anchor: JJ_MAIN_WINDOW
			-- Anchor for the type of `first_window'
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end

