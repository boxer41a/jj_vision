class LABEL_CONTROL

inherit

	CONTROL
		rename
			make as control_make
		redefine
			set_height, set_width
		end

create
	make

feature -- Initialization

	make (a_parent: WEL_COMPOSITE_WINDOW)
		do
			control_make (a_parent) 
			create static.make (Current, "New_Text", 0, 0, width, height, -1)
		end

	set_height (a_height: INTEGER)
		do
			resize (width, a_height)
			static.set_height (height)
		end

	set_width (a_width: INTEGER)
		do
			resize (a_width, height)
			static.set_width (width)
		end

feature

	set_data (a_string: STRING)
		do
			static.set_text (a_string)
		end

	data: STRING
		do
			Result := static.text
		end
	
	is_data_valid: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	static: WEL_STATIC

end -- class LABEL_CONTROL
