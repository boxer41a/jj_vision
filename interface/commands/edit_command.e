note
	description: "[
			Command used to change a field of an {EDITABLE}.
			]"
	date: "27 Jan 05"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/commands/edit_command.e $"
	date:		"$Date: 2013-04-25 18:11:22 -0400 (Thu, 25 Apr 2013) $"
	revision:	"$Revision: 14 $"

class
	EDIT_COMMAND

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

	make (a_record: like record; a_field: like field; a_value: like value)
			-- Initialize Current
		do
			default_create
			record := a_record
			field := a_field
			value := a_value
		end

feature -- Access

	text: STRING
			-- Name of this command
		do
			Result := "Edit record"
		end

	record: EDITABLE
			-- Object to be changed.

	field: FIELD
			-- FIELD which identifies the "item" to be changed

	value: ANY
			-- New value

	affected_objects: LINKED_SET [ANY]
			-- Set of objects changable by this command
		do
			create Result.make
			Result.extend (record)
		end

feature -- Element change

	set_record (a_record: like record)
			-- Change `record'
		require
			record_exists: a_record /= Void
		do
			record := a_record
		ensure
			record_assigned: record = a_record
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

	set_value (a_value: ANY)
			-- Change `value'.
		require
			value_exists: a_value /= Void
		do
			value := a_value
		ensure
			value_assigned: value = a_value
		end

feature -- Basic operations

	execute
			-- Perform the command
		do
			if record.has_value (field.label) then
				old_field := field
				old_value := record.value (field.label)
			end
			record.extend_value (value, field.label)
			Precursor {JJ_COMMAND}
		end

	undo
			-- Undo the command
		do
			if attached old_field as of then
				record.extend_value (of, field.label)
			else
				record.remove_value (field.label)
			end
			Precursor {JJ_COMMAND}
		end

feature -- Status report

	is_executable: BOOLEAN
			-- Can the command be executed?
		do
			Result := Precursor {JJ_COMMAND} and then
					record /= Void and field /= Void and value /= Void
		end

	is_undoable: BOOLEAN
			-- Can the command be undone?
		do
			Result := Precursor {JJ_COMMAND} and then
				(record /= Void and (old_field /= Void implies old_value /= Void)) and
				record.has_value (field.label)
		end

feature {NONE} -- Implementation

	old_value: detachable ANY
			-- Hold on to the old value in case of `undo'

	old_field: detachable FIELD
			-- Hold the old field.  If Void we know that the record previously
			-- did not have a field for the one just added by `execute', so
			-- `undo' will remove  `field'.

end
