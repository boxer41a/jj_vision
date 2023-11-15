note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2012-03-16 14:05:07 -0400 (Fri, 16 Mar 2012) $"
	revision: "$Revision: 7 $"

class
	YMDHMS_TIME_FIELD

inherit

	FIELD
		redefine
			default_create
		end

create
	default_create

feature -- Initialization

	default_create
		do
			Precursor {FIELD}
		end

feature -- Access

	data: YMDHMS_INTERVAL
		once 
			create Result.make
		end

feature -- Transformation

	as_widget: YMDHMS_TIME_CONTROL
		do
			create Result
--			Result.set_data (data)
		end



end
