note
	description: "[
		Item for placement into a {HISTORY_DROPDOWN}, pairing 
		an {EDITABLE} with a `time_stamp'.
		]"
	date: "23 Aug 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/support/history_item.e $"
	date:		"$Date: 2015-10-24 07:32:40 -0700 (Sat, 24 Oct 2015) $"
	revision:	"$Revision: 23 $"

class
	HISTORY_ITEM

inherit

	COMPARABLE
		undefine
			default_create,
			copy
		end

	VIEW
		rename
			parent as view_parent,
			pixmap as view_pixmap
		undefine
--			default_create,
			is_equal,
			copy
		redefine
			create_interface_objects,
			initialize,
			set_target,
			draw
		end

	EV_LIST_ITEM
		rename
			object_id as ise_object_id
		undefine
			is_equal,
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end

create
	make

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {VIEW}
			Precursor {EV_LIST_ITEM}
			create time_stamp
		end

	initialize
			-- Setup current
		do
			Precursor {EV_LIST_ITEM}
			Precursor {VIEW}
		end

feature -- Access

	time_stamp: YMDHMS_TIME
			-- To keep track of objects creation time

feature -- Element change

	set_target (a_target: like target)
			-- change `target'
		do
			Precursor {VIEW} (a_target)
			reset_time_stamp
			draw
		end

	reset_time_stamp
			-- Make `time_stamp' be the current system time
		do
			time_stamp := create {YMDHMS_TIME}.set_now
		end

feature -- Querry

	is_simular (a_other: like Current): BOOLEAN
			-- Does Current and other contain the same `target'?
		require
			other_exists: a_other /= Void
		do
			Result := target = a_other.target
		ensure
			definition: Result implies target = a_other.target
		end

feature -- Comparison

	is_less alias "<" (a_other: like Current): BOOLEAN
			-- Is Current less than `a_other'?
		do
			Result := (time_stamp < a_other.time_stamp)
		end

feature {NONE} -- Implementation

	pointer_button_release_actions: EV_POINTER_BUTTON_ACTION_SEQUENCE
			-- Actions to be performed when screen pointer button is pressed.
			-- Defined here as place-holder to be undefined (i.e. joined) to
			-- the version from {EV_WIDGET} or {EV_MODEL}.
			-- See index clause for information on pick-and-put.
		obsolete
			"Do not call; deferred in {VIEW} to implement pick-and-put"
		do
			create Result
			check
				do_not_call: false
					-- Because this feature should be UNDEFINED and the
					-- version from {EV_WIDGET} or {EV_MODEL} called.
			end
		end

	draw
			-- Put the correct text into this EV_LIST_ITEM.
		do
			if not is_view_empty then
				if attached {EDITABLE} target as e then
					set_text (e.display_name)
				else
					set_text (target.generating_type + " " + time_stamp.as_string)
				end
			end
		end

	view_parent: EV_FIXED
			-- Not used.
			-- Result type is just so it conforms for redefinition.
		do
			check
				do_not_call: False then
			end
		end

invariant

	time_stamp_exists: time_stamp /= Void
	target_exists: target /= Void

end
