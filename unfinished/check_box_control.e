note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision: "$Revision: 7 $"

class
	CHECK_BOX_CONTROL

inherit

	CONTROL
		redefine
			value,
			field,
			default_field,
			refresh
		end

create
	default_create,
	make_from_field

feature {NONE} -- Initialization

	initialize
			-- Set up the control
		do
			Precursor {CONTROL}
			prune (display)
			create check_box
			extend (check_box)
		end

feature -- Access

	field: CHECK_BOX_FIELD

	value: BOOLEAN

feature -- Basic operations

	refresh
			--
		do
			if is_valid (data) then
				b ?= data
				check
					go_assignment: d /= Void	-- would not be valid otherwise
				end
				if b then
					enable_select
				else
					disable_select
				end
			end
		end

feature {NONE} -- Implementation

	check_box: EV_CHECK_BUTTON

	default_field: CHECK_BOX_FIELD
			-- Create a field to be used if Current was `default_create'd.
			-- Assume it is a STRING.
		do
			create Result
		end


end -- class CHECK_BOX_CONTROL
