note
	description	: "[
		This class ties together the concept of EV_FIGURE_WORLD, EV_DRAWING_AREA,
		and EV_DRAWING_AREA_PROJECTOR in a simpler interface.  
		In order to fake out Eiffel Vision to allow a widget to be decreased in
		size (I call this the `set_minimum_size' problem'), the drawing
		area is contained in an EV_FIXED allowing the drawing area's size
		to follow that of the fixed, and thereby, indirectly the size of the
		parent window.  
		
		While this worked for the editor classes it does not seem to work here.
		I don't know why.  Is the problem with `resize_fixed' or with the fact
		that, in the graphics program where it is used, I am also using the
		"jj_vision" classes.  Perhaps the problem is there.???
		]"
	date: "27 Sep 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/jj_figure_world_view.e $"
	date:		"$Date: 2012-05-31 14:05:35 -0400 (Thu, 31 May 2012) $"
	revision:	"$Revision: 10 $"

class
	JJ_FIGURE_WORLD_VIEW

inherit

	EV_FRAME
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end

	VIEW
		undefine
--			default_create,
			copy
		redefine
			create_interface_objects,
			initialize,
			draw
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {VIEW}
			Precursor {EV_FRAME}
			create fixed
			create world
			create drawing_area
			create projector.make (world, drawing_area)
		end

	initialize
			-- Set up the widget
		do
			Precursor {VIEW}
			Precursor {EV_FRAME}
			extend (drawing_area)
			set_actions
--			draw
		end

	set_actions
		do
			resize_actions.force_extend (agent draw)
			drawing_area.expose_actions.force_extend (agent draw)
		end

feature -- Access

	world: EV_FIGURE_WORLD
			-- World which Current will manipulate.

	drawing_area: EV_DRAWING_AREA
			-- Area on which `world' will be projected.
			-- It is contained within a `fixed' area of Current.
			-- Exported to allow direct drawing on it.

feature -- Element change

	set_world (a_world: EV_FIGURE_WORLD)
			-- Change the `world' of figures to be displayed
		require
			world_exists: a_world /= Void
		do
			world := a_world
			projector.set_world (a_world)
		end

feature {NONE} -- Drawing / Refresh operations

	draw
			-- Build the view
		do
			drawing_area.clear
			if projector /= Void then
				projector.full_project
			end
		end

feature {NONE} -- Implementation

	projector: EV_DRAWING_AREA_PROJECTOR
			-- For projecting the world onto the drawing area.

	fixed: EV_FIXED
			-- Container placed in the EV_FRAME to control size of `drawing_area'.

end
