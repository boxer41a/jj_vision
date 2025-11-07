note
	description: "[
		Root class for commands, allowing undo and redo, and to 
		facilitate history functions.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/commands/jj_command.e $"
	date:		"$Date: 2014-06-15 09:17:19 -0400 (Sun, 15 Jun 2014) $"
	revision:	"$Revision: 18 $"

class
	JJ_COMMAND

inherit

	ANY
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Set up the command
		do
			create explanation.make
			create affected_objects_imp.make
		end

feature -- Access

	text: STRING
			-- Texual representation of what the command does.
		do
			Result := "do nothing"
		end

	explanation: LINKED_LIST [STRING]
			-- List of reasons why a command was not executed or undone
			-- Can be queried after a call to `is_executable' or `is_undoable'

feature -- Basic operations

	execute
			-- Execute the action represented by the command.
		require
			executable: is_executable
		do
				-- Current adds itself to the command manager
			was_executed := True
		end

	undo
			-- Reverse the action performed in `execute'.
		require
			undoable: is_undoable
		do
			was_executed := False
		end

	affected_objects: LINKED_SET [ANY]
			-- List of objects that executing this command affects, which
			-- can be used for other actions, such as updating views that
			-- contain these objects.
			-- Descendants should add to this set as needed.
		do
			Result := affected_objects_imp
		end

feature -- Status report

	is_executable: BOOLEAN
			-- Can the command be executed?
		do
			explanation.wipe_out
			Result := not was_executed
			if not Result then
				explanation.extend ("Command already executed")
			end
		end

	is_undoable: BOOLEAN
			-- Can the command be undone?
		do
			explanation.wipe_out
			Result := was_executed
			if not Result then
				explanation.extend ("Command not yet executed")
			end
		end

	was_executed: BOOLEAN
			-- Has the command been executed?

feature {NONE} -- Implementation

	affected_objects_imp: like affected_objects
			-- List of objects affected by Current

end

