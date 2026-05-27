note
	description: "[
		A combination of {EV_RICH_TEXT} and {EV_GRID_ITEM} for
		placement in an {EV_GRID}.
		The {EV_RICH_TEXT} features are implemented through a
		client relations in feature `text'.
		]"
	author: "Jimmy J. Johnson"
	date: "5/25/26"


class
	JJ_RICH_TEXT_GRID_ITEM

inherit

	EV_GRID_ITEM
		redefine
			create_interface_objects,
			initialize
		end

create
	default_create
	
feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor
			create text_imp
		end

	initialize
			-- Set up the view
		local
			f: EV_FONT
		do
			Precursor
		end

feature -- Access

	text: STRING_32
			-- The text displayed in Current
		do
			Result := text_imp.text
		end

feature -- Element change

	set_text (a_string: READABLE_STRING_GENERAL)
			-- Change the `text'
		do
			text_imp.set_text (a_string)
		end

feature {NONE} -- Implementation

	text_imp: EV_RICH_TEXT
			-- Implementation of `text' and handle to EV_RICH_TEXT functions

end
