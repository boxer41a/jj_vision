note
	description: "[
		A list of {FIELD} where each {FIELD} describes the placement
		of a {CONTROL} withing an {EDITOR}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/fields/schema.e $"
	date:		"$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision:	"$Revision: 7 $"

class
	SCHEMA

inherit

	LINKED_LIST [FIELD]
		rename
			item as field
		redefine
			default_create,
			make,
			copy,
			is_equal,
				-- Redefine the following in order to set the time the schema was
				-- changed so the dialog editor can use it to determine if it needs
				-- to redraw the view.
			extend,
			put_front,
			put_left,
			put_right,
			merge_left,
			merge_right,
				-- Need to redefine the following in order to preserve the invariant
				-- dealing with the keys (key fields must reside in current).  If a
				-- field is removed from Current it can no longer be used as a key.
				-- Other features are defined in terms of this, so these four should
				-- take care of all features from LINKED_LIST.
			remove,
			replace,
			remove_right,
			wipe_out
		select
			make
		end

	LINKED_LIST [FIELD]			-- inherited identically as above except for `make'
		rename
			make as list_make,
			item as field
		redefine
			default_create,
--			make,
			copy,
			is_equal,
				-- Redefine the following in order to set the time the schema was
				-- changed so the dialog editor can use it to determine if it needs
				-- to redraw the view.
			extend,
			put_front,
			put_left,
			put_right,
			merge_left,
			merge_right,
				-- Need to redefine the following in order to preserve the invariant
				-- dealing with the keys (key fields must reside in current).  If a
				-- field is removed from Current it can no longer be used as a key.
				-- Other features are defined in terms of this, so these four should
				-- take care of all features from LINKED_LIST.
			remove,
			replace,
			remove_right,
			wipe_out
		end

	EDITABLE
		undefine
			is_equal
		redefine
			default_create,
			copy,
			is_equal
		end

create
	default_create
create {LINKED_LIST}
	make

feature {NONE} -- Initialization

	default_create
			-- Create an instance
			-- Redefined because `new_chain' from LINKED_LIST uses `make'.
		do
			list_make
			Precursor {EDITABLE}
			create keys_imp.make
			create mandatory_fields.make
			create time_modified.set_now_utc_fine
			extend_mandatory (Name_field)
		end

	make
			-- Called by `new_chain' from LINKED_LIST
		do
			Precursor {LINKED_LIST}
			default_create
		end

feature -- Access

	identifying_field: FIELD
			-- The field used to get a string which will identify an object.
		do
			Result := identifying_field_ref.field
		end

	keys: LINKED_SET [STRING]
			-- The keys to use in comparison of EDITABLEs using Current.
			-- NOTE:  Even though FIELDs are used in `keys_imp', ultimately the label
			-- of the FIELD will be used to access data in an EDITABLE, hence the result type.
		do
			create Result.make
			from keys_imp.start
			until keys_imp.exhausted
			loop
				Result.extend (keys_imp.item.label)
				keys_imp.forth
			end
		end

	key_fields: LINKED_SET [FIELD]
			-- The fields which are used as keys
		do
			create Result.make
			from keys_imp.start
			until keys_imp.exhausted
			loop
				Result.extend (keys_imp.item)
				keys_imp.forth
			end
		end

	Name_field: STRING_FIELD
			-- The FIELD used to access the "name" of the object.
		once
			create Result
			Result.set_label ("Name: ")
		end

	time_modified: YMDHMS_TIME
			-- Time at which a modification was made (such as adding
			-- or removing a field).

feature -- Element change

	set_identifying_field (a_field: STRING_FIELD)
			-- Change the `user_identifying_field'
		require
			field_exists: a_field /= Void
		do
			identifying_field_ref.set_field (a_field)
		ensure
			field_was_assigned: identifying_field = a_field
		end

feature -- Basic operations

	put_front (a_field: like field)
			-- Add `a_field' to beginning.
			-- Do not move cursor.
			-- Reset `time_modified'.
		do
			Precursor {LINKED_LIST} (a_field)
			time_modified.set_now_utc_fine
		end

	extend (a_field: like field)
			-- Add `a_field' to the end.
			-- Do not move cursor.
			-- Reset `time_modified'.
		do
			Precursor {LINKED_LIST} (a_field)
			time_modified.set_now_utc_fine
		end

	extend_mandatory (a_field: like field)
			-- Add `a_field' to Current and make it a manditory field.
			-- Reset `time_modified'.
		require
			is_extendible: extendible
		do
			check
				field_exists: a_field /= Void
			end
			mandatory_fields.extend (a_field)
			extend (a_field)
		ensure
			has_field: has (a_field)
			has_as_mandatory: has_mandatory (a_field)
		end

	put_left (a_field: like field)
			-- Add `a_field' to the left of cursor position.
			-- Do not move cursor.
			-- Reset `time_modified'.
		do
			Precursor {LINKED_LIST} (a_field)
			time_modified.set_now_utc_fine
		end

	put_right (a_field: like field)
			-- Add `a_field' to the left of cursor position.
			-- Do not move cursor.
			-- Reset `time_modified'.
		do
			Precursor {LINKED_LIST} (a_field)
			time_modified.set_now_utc_fine
		end

	merge_left (a_other: like Current)
			-- Merge `a_other' into current structure before cursor
			-- position. Do not move cursor. Empty `other'.
			-- Reset `time_modified'.
		do
			Precursor {LINKED_LIST} (a_other)
			time_modified.set_now_utc_fine
		end

	merge_right (a_other: like Current)
			-- Merge `a_other' into current structure after cursor
			-- position. Do not move cursor. Empty `other'.
			-- Reset `time_modified'.
		do
			Precursor {LINKED_LIST} (a_other)
			time_modified.set_now_utc_fine
		end

	remove
			-- Remove current item.
			-- Move cursor to right neighbor
			-- (or `after' if no right neighbor).
			-- Reset `time_modified'.
			-- Also, redefined to preserve invariant.
		do
			if attached {COMPARABLE_FIELD} field as cf then
				keys_imp.prune (cf)
			else
				-- Do not have to worry about it, because if `v' is not
				-- a COMPARABLE_FIELD it would never be in `keys' anyway.
			end
			Precursor {LINKED_LIST}
			time_modified.set_now_utc_fine
		end

	replace (v: like field)
			-- Replace current item by `v'.
			-- Reset `time_modified'.
			-- Also, redefined to preserve invariant.
		do
			if attached {COMPARABLE_FIELD} v as cf then
				keys_imp.prune (cf)
			else
				-- Do not have to worry about it, because if `v' is not
				-- a COMPARABLE_FIELD it would never be in `keys' anyway.
			end
			Precursor {LINKED_LIST} (v)
			time_modified.set_now_utc_fine
		end

	remove_right
			-- Remove item to the right of cursor position.
			-- Do not move cursor.
			-- Reset `time_modified'.
			-- Also, redefined to preserve invariant.
		do
			if attached {COMPARABLE_FIELD} i_th (index + 1) as cf then
				keys_imp.prune (cf)
			else
				-- Do not have to worry about it, because if `v' is not
				-- a COMPARABLE_FIELD it would never be in `keys' anyway.
			end
			Precursor {LINKED_LIST}
			time_modified.set_now_utc_fine
		end

	wipe_out
			-- Remove all items.
			-- Reset `time_modified'.
			-- Also, redefined to preserve invariant.
		do
			keys_imp.wipe_out
			Precursor {LINKED_LIST}
			time_modified.set_now_utc_fine
		end

	add_key_field (a_field: COMPARABLE_FIELD)
			-- Add `a_field' to use in comparisons
		require
			field_exists: a_field /= Void
			has_field: has (a_field)
		do
			keys_imp.extend (a_field)
		ensure
			has_key: keys_imp.has (a_field)
		end

	prune_key_field (a_field: COMPARABLE_FIELD)
			-- Remove `a_field' so it no longer is used in comparisons
		require
			field_exists: a_field /= Void
		do
			keys_imp.prune (a_field)
		ensure
			removed: not keys_imp.has (a_field)
		end

	promote_key_field (a_field: COMPARABLE_FIELD)
			-- Move `a_field' toward the beginning of `keys' by one, so it
			-- will be a "more important" key.
		require
			field_exists: a_field /= Void
			has_as_key: key_fields.has (a_field)
		local
			i: INTEGER
		do
			if keys_imp.count > 1 then
				i := keys_imp.index_of (a_field, 1)
				if i > 1 then
					go_i_th (i - 1)
					swap (i)
				end
			end
		ensure
			field_was_promoted:
		end

	demote_key_field (a_field: COMPARABLE_FIELD)
			-- Move `a_field' toward the end of `keys' by one, so it
			-- will be a "less important" key.
		require
			field_exists: a_field /= Void
			has_as_key: key_fields.has (a_field)
		local
			i: INTEGER
		do
			if keys_imp.count > 1 then
				i := keys_imp.index_of (a_field, 1)
				if i < count then
					go_i_th (i + 1)
					swap (i)
				end
			end
		ensure
			field_was_demoted:
		end

	set_key_primary (a_field: COMPARABLE_FIELD)
			-- Move `a_field' toward the end of `keys' by one, so it
			-- will be a "less important" key.
		require
			field_exists: a_field /= Void
			has_as_key: key_fields.has (a_field)
		local
			i: INTEGER
		do
			if keys_imp.count > 1 then
				i := keys_imp.index_of (a_field, 1)
				if i /= 1 then
					go_i_th (1)
					swap (i)
				end
			end
		ensure
			field_is_primary: key_fields.index_of (a_field, 1) = 1
		end

feature -- Querry

	has_mandatory (a_field: like field): BOOLEAN
			-- Is `a_field' required to always be in this schema?
			-- (I.e. can it never be deleted?)
		require
			field_exists: a_field /= Void
		do
			Result := mandatory_fields.has (a_field)
		ensure
			definition: Result = mandatory_fields.has (a_field)
		end

feature  -- Duplication

	copy (other: like Current)
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
			-- Redefined to merge the copy operations from both ancestors.
			-- NOTE:  Feature `infix "<"' from VIEWABLE only checks the `id'
			-- and assumes if the `id' (and hence the `time_stamp' from both
			-- objects are equal the object must have been copied and is
			-- therefore equal.
		do
			Precursor {LINKED_LIST} (other)
			Precursor {EDITABLE} (other)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is Current equal to `other'?
		do
				-- Precursor {VIEWABLE} uses feature `infix "<"' to do the
				-- comparison, and there is no less than feature in LINKED_LIST,
				-- therefore this feature makes the BIG assumption that if
				-- the `id' and `time_stamp' (from VIEWABLE) of both objects
				-- are the same then it must have been a copy.  There is no other
				-- way to make the `time_stamps' equal.
			Result := Precursor {EDITABLE} (other)
		end

feature {NONE} -- Implementation

	keys_imp: LINKED_SET [COMPARABLE_FIELD]
			-- Set of fields whose associated values can be used to compare
			-- one EDITABLE to another in feature `infix "<"' from EDITABLE.
			-- The order implies the more significant fields.

	mandatory_fields: LINKED_SET [FIELD]
			-- Set of fields which can not be deleted from Current.

	identifying_field_ref: FIELD_REF
			-- The field to be used as `identifying_field' as set by the user
			-- in place of the default field.
		once
			create Result.set_field (Name_field)
		end

invariant

	keys_imp_exists: keys_imp /= Void
	manditory_fields_exists: mandatory_fields /= Void
	keys_reside_in_current: key_fields.for_all (agent has)
	mandatory_fields_reside_in_current: mandatory_fields.for_all (agent has)

end
