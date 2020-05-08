note
	description: "[
				Used by {EDIT_TOOL} to add or remove a {FIELD} in a {SCHEMA}.
				Note:  this is not to be confused with {EDIT_COMMAND} which is used
				to change the "data" in a record or to change the positioning of a
				{FIELD}; this changes the {SCHEMA} itself.
				]"
	date: "6 Oct 07"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/commands/change_fields_command.e $"
	date:		"$Date: 2013-04-25 18:11:22 -0400 (Thu, 25 Apr 2013) $"
	revision:	"$Revision: 14 $"

class
	CHANGE_FIELDS_COMMAND

inherit

	JJ_COMMAND
		redefine
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

	make (a_schema: like schema; a_field: like field)
			-- Create an instance
		do
			default_create
			schema := a_schema
			field := a_field
		end

feature -- Access

	text: STRING
			-- Name of this command
		do
			Result := "Change schema"
		end

	schema: SCHEMA
			-- The SCHEMA being changed

	field: FIELD
			-- FIELD which identifies the "item" to be changed

	affected_objects: LINKED_SET [ANY]
			-- Set of objects changable by this command
		do
			Result := Precursor {JJ_COMMAND}
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

	set_field (a_field: FIELD)
			-- Change `field'
		require
			field_exists: a_field /= Void
		do
			field := a_field
		ensure
			field_assigned: field = a_field
		end

feature -- Basic operations

	execute
			-- Perform the command
		do
			Precursor {JJ_COMMAND}
			schema.time_modified.set_now_utc_fine
			if is_delete_command then
				schema.start
				schema.prune (field)
			else
				schema.extend (field)
			end
		end

	undo
			-- Undo the command
		do
			Precursor {JJ_COMMAND}
			schema.time_modified.set_now_utc_fine
			if is_delete_command then
				schema.extend (field)
			else
				schema.start
				schema.prune (field)
			end
		end

feature -- Status report

	is_executable: BOOLEAN
			-- Can the command be executed?
		do
			Result := Precursor {JJ_COMMAND} and then
					(schema /= Void and field /= Void) and then
					(is_delete_command implies schema.has (field))
		end

	is_undoable: BOOLEAN
			-- Can the command be undone?
		do
			Result := PRECURSOR {JJ_COMMAND} and then
					(schema /= Void and then field /= Void) and then
					(is_delete_command implies not schema.has (field))
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
