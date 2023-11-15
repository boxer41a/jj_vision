class YMD_INTERVAL_CONTROL

inherit

	WEL_EN_CONSTANTS	
		export
			{NONE} all
		end

	JJJ_CONTROL
		redefine
			make,
			notify,
			set_height,
			set_width
		end

create
	make

feature -- Initialization

	make (a_parent: WEL_COMPOSITE_WINDOW)
		do
			Precursor (a_parent) 
			create start_date_edit.make (Current) 
			create finish_date_edit.make (Current) 
			create duration_edit.make (Current) 
			create data.make
			start_date_edit.set_x (5)
			start_date_edit.set_y (5)
			finish_date_edit.set_x (5)
			finish_date_edit.set_y (start_date_edit.y + start_date_edit.height + 5)
			duration_edit.set_x (5)
			duration_edit.set_y (finish_date_edit.y + finish_date_edit.height + 5)
		end

	set_height (a_height: INTEGER)
		do
			Precursor (a_height)
			finish_date_edit.set_y (start_date_edit.y + start_date_edit.height + 5)
		end

	set_width (a_width: INTEGER)
		do
			Precursor (a_width)
			start_date_edit.set_width (width-10)
			finish_date_edit.set_width (width-10)
			duration_edit.set_width (width-10)
		end

feature -- Access

	data: YMD_INTERVAL

feature -- Element Change

	set_data (a_interval: like data)
		do
			data := a_interval
			start_date_edit.set_data (data.start)
			finish_date_edit.set_data (data.finish)
			duration_edit.set_data (data.duration)
		end

feature -- Status report

	is_data_valid: BOOLEAN
		do
--			if is_valid_date_string (text) then
--				set_date_string (text)
				Result := True
--			end
		end	


feature {NONE} -- Messages

	notify (a_control: WEL_CONTROL; a_notify_code: INTEGER)
		local
			p: WEL_COMPOSITE_WINDOW
		do
			if a_notify_code = En_change then
				if a_control = start_date_edit or a_control = finish_date_edit then
					data.set_start_finish (start_date_edit.data, finish_date_edit.data)
				elseif a_control = duration_edit then
					if not duration_edit.data.is_negative then
						data.set_start_duration (start_date_edit.data, duration_edit.data)
					end
				else
				end
				set_data (data)	
			end
			p ?= parent
			if p /= Void then
				p.notify (Current, En_change)
			end
		end

feature {NONE} -- Implementation

	start_date_edit: JJJ_EDIT_DATE

	finish_date_edit: JJJ_EDIT_DATE

	duration_edit: JJJ_EDIT_YMD_DURATION


end -- class YMD_INTERVAL_CONTROL
