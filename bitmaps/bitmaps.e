note
	description: "[
		Bitmaps created programatically from PIXEL_BUFFERS
		]"
	author: "Jimmy J. Johnson"
	date: "$Date: 2012-05-19 11:28:28 -0400 (Sat, 19 May 2012) $"
	revision: "$Revision: 9 $"

class
	BITMAPS

inherit

	PIXEL_BUFFERS

feature -- Access

	icon_back_color: EV_PIXMAP
		do
			create Result.make_with_pixel_buffer (Icon_back_color_buffer)
		end

end
