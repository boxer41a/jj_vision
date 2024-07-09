note
	description: "[
		A widget that can appear bright or dim
		]"
	author: "Jimmy J. Johnson"

deferred class
	DIMABLE

inherit

	ANY
		redefine
			default_create
		end

feature -- Initialization

	default_create
			-- Set the default `dimming_level'
		do
			dimming_level := Dimmer
			previous_dimming_level := Dimmest
		end

feature -- Access

	dimming_level: INTEGER_32
			-- The amount colors will be dimmed
			-- (One of `Dim', `Dimmer', or `Dimmest')

	previous_dimming_level: INTEGER_32
			-- Used to `restore' to the prior dimming level

	Bright: INTEGER = 0
	Normal: INTEGER_32 = 7
	Dim: INTEGER = 10
	Dimmer: INTEGER_32 = 15
	Dimmest: INTEGER_32 = 20

feature -- Element change

	set_dimming_level (a_level: like dimming_level)
			-- Change the `dimming_level'
		require
			valid_level: a_level = Bright or a_level = Normal or a_level = Dim or
						a_level = Dimmer or a_level = Dimmest
		do
--			io.put_string ("DIMABLE.set_dimming_level -- ")
--			if attached {VITP_ITEM} Current as v then
--				io.put_string ("on " + v.name)
--			else
--				io.put_string (" on?  " + generating_type)
--			end
--			io.put_string (" from " + previous_dimming_level.out)
--			io.put_string ("  to " + dimming_level.out + "%N")
			previous_dimming_level := dimming_level
			dimming_level := a_level
		end

feature -- Basic operations

	restore_dimming_level
			-- Set the `dimming_level' to the `previous_dimming_level'
		do
			set_dimming_level (previous_dimming_level)
		end

feature -- Status report

	is_bright: BOOLEAN
			-- Should the resulting colors be "bright"?
		do
			Result := dimming_level = Bright
		end

	is_normal: BOOLEAN
			-- Should the resulting colors be "normal"?
		do
			Result := dimming_level = Normal
		end

	is_dimmed: BOOLEAN
			-- Should the resulting colors be "dim"?
		do
			Result := dimming_level = Dim
		end

	is_more_dimmed: BOOLEAN
			-- Should the resulting colors be "dimmer"?
		do
			Result := dimming_level = Dimmer
		end

	is_completely_dimmed: BOOLEAN
			-- Should the resulting colors be "dimmest"?
		do
			Result := dimming_level = Dimmest
		end

feature -- Status setting

	set_bright
			-- Change the color dimming level to "bright
		do
			set_dimming_level (Bright)
		end

	set_normal
			-- Change the `dimming_level' to "normal"
		do
			set_dimming_level (normal)
		end

	set_dimmed
			-- Change the color dimming level to "dim"	
		do
			set_dimming_level (Dim)
		end

	set_more_dimmed
			-- Change the color dimming level to `Dimmer'
		do
			set_dimming_level (Dimmer)
		end

	set_completely_dimmed
			-- Change the color dimming level to `Dimmest'
		do
			set_dimming_level (Dimmest)
		end

feature -- Query

	adjusted_color (a_color: EV_COLOR): EV_COLOR
			-- A new color from `a_color' adjusted based on the `dimming_level'
		require
			color_exists: a_color /= Void
		do
			fader.set_color (a_color)
			Result := fader.i_th_lighter (dimming_level)
		end

	dim_color (a_color: EV_COLOR): EV_COLOR
			-- A new color based on `a_color' at a "faded" level
		require
			color_exists: a_color /= Void
		do
			fader.set_color (a_color)
			Result := fader.i_th_lighter (Dim)
		end

	dimmer_color (a_color: EV_COLOR): EV_COLOR
			-- A new color based on `a_color' at a "faded" level
		require
			color_exists: a_color /= Void
		do
			fader.set_color (a_color)
			Result := fader.i_th_lighter (Dimmer)
		end

	dimmest_color (a_color: EV_COLOR): EV_COLOR
			-- A new color based on `a_color' at a "faded" level
		require
			color_exists: a_color /= Void
		do
			fader.set_color (a_color)
			Result := fader.i_th_lighter (Default_step_count)
		end

feature {NONE} -- Implementation

	fader: COLOR_FADER
			-- Used to calculate a new color based on some initial color and dimming level
		once
			create Result
			Result.set_count (Default_step_count)
		end

	Default_step_count: INTEGER_32 = 20
			-- Number of variable color settings used in the `fader'

invariant

	valid_dimming_level: dimming_level = Bright or
							dimming_level = Normal or
							dimming_level = Dim or
							dimming_level = Dimmer or
							dimming_level = Dimmest

end
