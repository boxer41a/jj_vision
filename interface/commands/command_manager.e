note
	description: "[
				Objects used by {JJ_APPLICATION} to allow commands to be
				undone and redone.
				]"
	date: "2 Oct 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/commands/command_manager.e $"
	date:		"$Date: 2012-07-01 01:30:44 -0400 (Sun, 01 Jul 2012) $"
	revision:	"$Revision: 12 $"

class
	COMMAND_MANAGER

inherit

	SHARED
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

	LINKED_LIST [JJ_COMMAND]
		export
			{LINKED_LIST}
				all
--			{NONE}
--				all
--			{LINKED_LIST}
--				start,
--				forth,
--				first_element,
--				last_element,
--				count,
--				object_comparison,
--				cursor,
--				go_to,
--				index
			{ANY}
				wipe_out,
				prunable,
--				item,
				is_empty,
--				readable,
--				off,
				has,
				is_equal
--				standard_is_equal,
--				copy,
--				same_type
		redefine
			default_create,
			wipe_out
		end

create
	default_create, make

feature {NONE} -- Initialization

	default_create
			-- Initialize `Current'.
		do
			make
		end

feature -- Access

	marked_index: INTEGER
			-- Mark the command at current `last_executed_index'

	last_executed_index: INTEGER
			-- Index of last executed (and next undoable) command.

	command: JJ_COMMAND
			-- Last inserted command.
		require
			not_empty: not is_empty
		do
			Result := i_th (last_executed_index)
		end

feature -- Element change

	add_command (a_command: JJ_COMMAND)
			-- Remove any commands which have been undone (they will not be
			-- executable after `a_command' is added), then add `a command'
			-- to the list and execute it.
		require
			not_has_command: not has (a_command)
		do
			from go_i_th (last_executed_index + 1)
			until after or else is_empty
			loop
				remove
			end
			extend (a_command)
			execute
			check
				last_executed_index = index_of (a_command, 1)
			end
		ensure
			command_added: has (a_command)
			command_executed: last_executed_index = count
		end

	set_mark
			-- Save a reference to the currently undoable command.
			-- Useful for marking the command state at which a
			-- system was saved.
		do
			marked_index := last_executed_index
		end

feature -- Status report

	is_undoable: BOOLEAN
			-- Can a command be undone?
		do
			Result := last_executed_index > 0
		end

	is_executable: BOOLEAN
			-- Is there a command which can be executed?
			-- That is, was one previousely undone or added?
		do
			Result := last_executed_index + 1 <= count
		end

	is_at_marked_state: BOOLEAN
			-- Is the cursor at item which was marked_index.
			-- Useful for marking and checking if / when a system was saved.
		do
			Result := last_executed_index = marked_index
		end

feature -- Basic operations

	wipe_out
			-- Remove all commands from Current, erasing history.
		do
			Precursor
			last_executed_index := 0
			marked_index := 0
		end

	execute
			-- Execute the command at `last_executed_index'.
		require
			can_execute_a_command: is_executable
		local
			v: VIEW
			c: JJ_COMMAND
		do
			last_executed_index := last_executed_index + 1
			c := i_th (last_executed_index)
			c.execute
--			Persistence_manager.extend_objects (c.affected_objects)
				-- Get a view so the views with the objects changed
				-- by executing the command can be updated.
			v := main_windows.first
			v.draw_views_with_set (c.affected_objects)
				-- Call `set_widget_states' to update the undo, redo, and save, etc. buttons.
			main_windows.do_all (agent {JJ_MAIN_WINDOW}.set_widget_states)
		ensure
			last_executed_index_incremented: last_executed_index = old last_executed_index + 1
		end

	undo
			-- Reverse execute the last command.
		require
			can_undo_a_command: is_undoable
		local
			v: VIEW
			c: JJ_COMMAND
		do
				-- Get the command at the current index and undo it.
			c := i_th (last_executed_index)
			c.undo
			last_executed_index := last_executed_index - 1
--			persistence_manager.extend_objects (c.affected_objects)
				-- Need to get a view so the views with the objects changed
				-- by undoing the command can be updated.
			v := main_windows.first
			v.draw_views_with_set (c.affected_objects)
				-- Call `set_widget_states' to update the undo, redo, and save, etc. buttons.
			main_windows.do_all (agent {JJ_MAIN_WINDOW}.set_widget_states)
		ensure
			last_executed_index_decremented: last_executed_index = old last_executed_index - 1
		end

feature {NONE} -- Implementation (Handles to "global" application objects)

--	Persistence_manager: PERSISTENCE_MANAGER is
--			-- Handle (for convinience) to the JJ_APPLICATION's `persistence_manager'.
--		local
--			app: JJ_APPLICATION
--		once
--			app ?= (create {EV_ENVIRONMENT}).application
--			check
--				app /= Void
--					-- Because this class if for use by a JJ_APPLICATION
--			end
--			Result := app.persistence_manager
--		ensure
--			result_exists: Result /= Void
--		end

end

