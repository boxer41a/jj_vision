note
	description: "[
				Used by {EDIT_TOOL} to change a {FIELD} in a {SCHEMA}.
				Note:  this is not to be confused with {EDIT_COMMAND} which is used
				to change the "data" in a record or to change the positioning of a
				{FIELD}; this changes the {SCHEMA} itself.
				]"
	date: "16 Mar 06"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/commands/edit_schema_command.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	EDIT_SCHEMA_COMMAND

inherit

	EDIT_COMMAND
		redefine
			make,
			text,
			affected_objects,
			execute,
			undo,
			is_executable,
			is_undoable
		end

create
	make

feature {NONE} -- Initialization

	make (a_record: like record; a_field: like field; a_value: like value)
			-- Initialize Current
		do
			Precursor (a_record, a_field, a_value)
			create schema
		end

feature -- Access

	text: STRING
			-- Name of this command
		do
			Result := "Edit schema"
		end

	schema: SCHEMA
			-- The SCHEMA being changed

	affected_objects: LINKED_SET [ANY]
			-- Set of objects changable by this command
		do
			Result := Precursor {EDIT_COMMAND}
			Result.extend (schema)
			Result.extend (field)
		end

feature -- Element change

	set_schema (a_schema: like schema)
			-- Change `schema'
		require
			schema_exists: a_schema /= Void
		do
			schema := a_schema
		ensure
			schema_assigned: schema = a_schema
		end

feature -- Basic operations

	execute
			-- Perform the command
		do
			schema.time_modified.set_now_utc_fine
			Precursor {EDIT_COMMAND}
		end

	undo
			-- Undo the command
		do
			schema.time_modified.set_now_utc_fine
			Precursor {EDIT_COMMAND}
		end

feature -- Status report

	is_executable: BOOLEAN
			-- Can the command be executed?
		do
			Result := Precursor {EDIT_COMMAND} and then
					(schema /= Void and field /= Void)
		end

	is_undoable: BOOLEAN
			-- Can the command be undone?
		do
			Result := PRECURSOR {EDIT_COMMAND} and then
					(schema /= Void and field /= Void)
		end

feature -- Status setting

	set_delete_action
			-- Make this command delete `field' from `schema' when `execute' is called.
		do
			is_delete_command := True
		end

	set_add_action
			-- Make this command add `field' to `schema' when `execute' is called.
		do
			is_delete_command := False
		end

feature {NONE} -- Implementation

	is_delete_command: BOOLEAN
			-- Is this command to be used to delete `field' from `schema'?

end
