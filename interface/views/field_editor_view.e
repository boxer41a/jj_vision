note
	description: "[
		An special {DIALOG_EDITOR_VIEW} used to edit a {FIELD}  
		
		A {FIELD_SCHEMA} can not be created when a {FIELD} is created, 
		because, as Manu from ISE described, both {FIELD} and {SCHEMA} 
		would rely on the creation of the other, and an object would 
		be referenced before the created object was ever assigned to 
		the `Result' in `default_create'.
		]"
	date: "27 Feb 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/field_editor_view.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	FIELD_EDITOR_VIEW

inherit

	DIALOG_EDITOR_VIEW
		redefine
			record_imp,
			set_record,
			new_edit_command
		end

create
	default_create

feature -- Element change

	set_record (a_record: like record)
			-- Change the `record'.
		do
				-- Redefined to ensure the `schema' for `a_record' is set.
				-- It may alread be here, but not always.
				-- Note that `draw' is called by Precursor.
			set_schema (a_record.schema)
			Precursor {DIALOG_EDITOR_VIEW} (a_record)
		end

feature {NONE} -- Implementation (actions)

	parent_schema: SCHEMA
			-- The schema being editted by the `parent_tool' which
			-- must be a EDIT_TOOL.
		do
			check attached {EDIT_TOOL} parent_tool as pt then
				Result := pt.get_schema
			end
		end

	new_edit_command (a_record: like record; a_field: FIELD; a_value: ANY): EDIT_SCHEMA_COMMAND
			-- Used by `save_record' to get the correct type of command.
			-- It is special for this type as it is a field that is
			-- changing but the command affects a SCHEMA.
		do
			create Result.make (a_record, a_field, a_value)
			Result.set_schema (parent_schema)
		end

	record_imp: detachable FIELD
			-- Detachable implementation of `target' for void-safety

end
