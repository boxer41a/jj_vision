class YMD_DURATION_CONTROL

inherit

	WEL_SS_CONSTANTS
		export
			{NONE} all
		end

	WEL_EN_CONSTANTS
		export
			{NONE} all
		end

	YMD_DURATION_PARSER
		rename
			make as parser_make
		export
			{NONE} all
		end

	CONTROL
		redefine
			make,
			on_control_command,
			set_height,
			set_width
		end

create
	make

feature -- Initialization

	make (a_parent: WEL_COMPOSITE_WINDOW)
		local
			button_size: INTEGER
		do
			parser_make
			Precursor (a_parent) 
			create static.make (Current, "", 0, 0, 50, 20, -1) 
			create up_button.make (Current, "+", 40, 0, 10, 10, -1) 
			create down_button.make (Current, "-", 40, 10, 10, 10, -1)
		end

	set_height (a_height: INTEGER)
		local
			but_size: INTEGER
		do
			Precursor (a_height)
			but_size := height // 2
			static.set_height (height)
			static.set_width (width - but_size-1)
			up_button.set_x (static.width+1)
			down_button.set_y (static.width+1)
			up_button.set_height (but_size)
			up_button.set_width (but_size)
			down_button.set_height (but_size)
			down_button.set_width (but_size)
		end

	set_width (a_width: INTEGER)
		local
			but_size: INTEGER
		do
			Precursor (a_width)
			but_size := height // 2
			static.set_width (width - but_size-1)
			up_button.set_x (static.width+1)
			down_button.set_x (static.width+1)
		end


feature {NONE} -- Messages

	on_control_command (control: WEL_CONTROL)
		local
			temp: WEL_CONTROL_WINDOW
		do
			temp ?= parent
			if control = up_button then
				increment
				temp.notify (Current, En_change)
			elseif control = down_button then
				decrement
				temp.notify (Current, En_change)
			else
			end
		end

feature -- Access

	data: YMD_DURATION
--	data: YMD_DURATION is
--		do
--			Result := date
--		end

feature -- Element Change

	set_data (a_duration: YMD_DURATION)
		do
			data := a_duration
			static.set_text (to_string (data))
		end

feature -- Status report

	is_data_valid: BOOLEAN
		do
			Result := True
		end


feature {NONE} -- Implementation

	static: WEL_STATIC

	up_button: WEL_PUSH_BUTTON

	down_button: WEL_PUSH_BUTTON

	increment
		local
			one_day: YMD_DURATION
		do 
			create one_day.make
			one_day.set (0,0,1)
			data.add (one_day)
			static.set_text (to_string (data))
		end

	decrement
		local
			one_day: YMD_DURATION
		do 
			create one_day.make
			one_day.set (0,0,1)
			data.sub (one_day)
			static.set_text (to_string(data))
		end


end
