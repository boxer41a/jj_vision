note
	description: "[
		Used with EDITOR classes.
		Object which can be edited in a dialog box, an {EDITOR} using
		a format stored in a `schema'.
		]"
	date: "7 Mar 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/system/editable.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	EDITABLE

inherit

	TIME_STAMPABLE
		redefine
			default_create
--			infix "<"
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			Precursor {TIME_STAMPABLE}
			create data_table.make (5)
			schema_imp := Default_schema
		end

feature -- Access

	value (a_key: STRING): detachable ANY
			-- The value associated with `key' or Void if none.
		require
			key_exists: a_key /= Void
		do
			Result := data_table.item (a_key)
		end

	schema: SCHEMA
			-- Used to construct a dialog in which to edit the values
			-- which are then stored in `data_table'.
		require
			schema_available: is_schema_available
		do
			check attached schema_imp as s then
				Result := s
			end
		ensure
			result_exists: Result /= Void
		end

	display_name: STRING_32
			-- Used as an "out" value for display in TOOLs and other widgets.
		do
			if attached {STRING} value (schema.identifying_field.label) as s then
				Result := s
			else
				Result := Current.id
			end
		end

feature -- Element change

	set_target_label_field (a_field: STRING_FIELD)
			-- Change the field used to display an identifier in the tools, etc.
			-- This is really in the `schema' of the editable.
		require
			field_exists: a_field /= Void
		local
			w: JJ_MAIN_WINDOW
		do
			schema.set_identifying_field (a_field)
				-- Because `target_label_field' is posibly used by all views, when it changes
				-- all views must be updated because there is no way for the view to know
				-- if it contains `target_label_field'.  Originally `target_label_field'
				-- was added to the views using `add_object' (see VIEW), but using a FIELD
				-- implies some EDITABLEs in the system.  I wanted the "Standard Interface"
				-- cluster to stand alone and not need the "Dynamic Editor" cluster to which
				-- this class belongs.
			check attached {JJ_APPLICATION} (create {EV_ENVIRONMENT}).application as a then
					-- because only JJ_APPLICATIONS should use this.  really ???
				-- Get hold of any VIEW; `first_window' will work.
				w := a.first_window
				w.draw_all_views
			end
		end

	set_schema (a_schema: like schema)
			-- Change `schema' indirectly by changing `schema_imp'.
		require
			schema_exists: a_schema /= Void
		do
			schema_imp := a_schema
		ensure
			schema_was_set: schema = a_schema
		end

	remove_schema
			-- Make `schema_imp' Void
		do
			schema_imp := Void
		ensure
			schema_imp_void: schema = Void
		end

	extend_value (a_value: ANY; a_key: STRING)
			-- Add `a_value' to the `data_table' and associate it with `a_key'
			-- and accessable through feature `value'.
			-- NOTE:  `a_value' can be Void.
		require
			key_exists: a_key /= Void
			value_exists: a_value /= Void	-- temp
		do
			data_table.force (a_value, a_key)
		ensure
			has_value: a_value /= Void implies data_table.has_item (a_value)
			has_key: data_table.has (a_key)
		end

	remove_value (a_key: STRING)
			-- Remove the value associated with `a_key' and `a_key'.
		require
			key_exists: a_key /= Void
		do
			data_table.remove (a_key)
		ensure
			not_has_value: not data_table.has (a_key)
			not_has_key: not data_table.has (a_key)
		end

--	extend_with_field (a_value: ANY; a_field: FIELD) is
--			-- Change the value of the data as index using the `name' from `a_field'.
--			-- NOTE:  `a_value' can be Void.
--		require
--			field_exists: a_field /= Void
--			schema_has_field: schema.has (a_field)
--		do
--			extend (a_value, a_field.label)
--		ensure
--			has_value: a_value /= Void implies data_table.has_item (a_value)
--			has_key: data_table.has (a_field.label)
--		end

--	change (a_control: VALUE_KEY_PAIR) is
--			-- Change the `value' in Current to the value stored in `a_control'
--			-- NOTE: `a_control' contains a `key' / `value' pair.
--		do
--			data_table.force (a_control.value, a_control.key)
--		end

	remove_unreachable_data
			-- Remove any data from this EDITABLE that cannot be
			-- accessed	using the keys in `a_key_set' or the
			-- `keys' in `template'.
		do
		end

feature -- Status report

	is_schema_available: BOOLEAN
			-- Does Current have a schema?
		do
			Result := schema_imp /= Void
		end

feature -- Query

	has_schema (a_schema: SCHEMA): BOOLEAN
			-- Does `schema' equal `a_schema'?
		require
			schema_exists: a_schema /= Void
		do
			Result := schema = a_schema
		end

	has_value (a_key: STRING): BOOLEAN
			-- Is there a value associated with `a_key'?
		require
			key_exists: a_key /= Void
		do
			data_table.search (a_key)
			Result := data_table.found
		end

feature -- Comparison

	is_less alias "<" (a_other: like Current): BOOLEAN
			-- Is Current less than `a_other'?
			-- This uses the `keys' from `schema' first and then the `id'.
		do
			if not (Current = a_other) then
				if schema = Void and a_other.schema = Void then
					Result := Current < a_other
				elseif schema /= Void and a_other.schema = Void then
					Result := True
				elseif schema = Void and a_other.schema /= Void then
					Result := False
				elseif schema /= Void and a_other.schema /= Void then
					Result := compare_key_values (a_other)
				end
			end
		ensure then
			zero_schemas: (schema = Void and a_other.schema = Void) implies Result = (Current < a_other)
			one_schema_current: (schema /= Void and a_other.schema = Void) implies Result
			one_schema_other: (schema = Void and a_other.schema /= Void) implies not Result
			same_schema_both: (schema /= Void and a_other.schema /= Void) implies Result = compare_key_values (a_other)
		end

feature {NONE} -- Implementation

	compare_key_values (a_other: like Current): BOOLEAN
			-- Is Current less than `a_other' when comparing keys?
			-- Feature to decompose `infix "<"'.
		require
			other_exists: a_other /= Void
			schema_exists: schema /= Void
			other_schema_exists: a_other.schema /= Void
		local
			keys: LINKED_SET [STRING]
			k: STRING
			done: BOOLEAN
		do
			keys := schema.keys
			if schema /= a_other.schema then
				keys.intersect (a_other.schema.keys)
			end
			from keys.start
			until done or else keys.exhausted
			loop
				k := keys.item
					-- Now compare the values.  If both are Void (can happen) or reference
					-- the same object (unlikely or imposible) then just continue to
					-- the next key.  If they are not equal then do comparison.
				if attached {COMPARABLE} value (k) as c and
						attached {COMPARABLE} a_other.value (k) as other_c then
					Result := c < other_c
					done := True
				end
				keys.forth
			end
				-- At this point we have either made a determination using the
				-- values at the keys, in which case `done' will be true, or we
				-- have exhausted the keys without making a determination.  In
				-- the second case compare the `id' features; this should be
				-- true if Current was created before `a_other'.  (Feature `id'
				-- incorporates a `time_stamp'.)
			if not done then
				Result := Current.id < a_other.id
			end
		end

feature {NONE}-- Implementation

	schema_imp: detachable like schema
			-- Implementation of `schema'. Set by `set_schema' and
			-- removed by `remove_schema.
			-- NOTE:  The FIELDs in a SCHEMA will determine the keys to be
			-- used in `data_table' and will be used to build the controls
			-- for obtaining the values asscociated with the keys.

	data_table: HASH_TABLE [ANY, STRING]
			-- The actual data is stored here.		

	Default_schema: SCHEMA
			-- Schema available to all EDITABLEs
		once
			create Result
		end

invariant

--	data_table_exists: data_table /= Void

end
