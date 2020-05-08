class YMD_INTERVAL_FIELD
	-- creates an edit box.

inherit

	FIELD
		redefine
			make
		end

create
	make


feature -- Initialization

	make
		do
			Precursor
			set_height (150)
		end

feature -- Access

	data: YMD_INTERVAL
		once 
			create Result.make
		end

feature -- Transformation

	as_control (a_parent: WEL_COMPOSITE_WINDOW): JJJ_EDIT_YMD_INTERVAL
		do 
			create Result.make (a_parent)
			Result.set_x (x)
			Result.set_y (y)
			Result.set_width (width)
			Result.set_height (height)
			Result.set_data (data)
		end

end -- class DMY_INTERVAL_FIELD
