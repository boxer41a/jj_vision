note
	description: "[
		A {VIEW} used to display the names of files as filtered
		]"
	date: "26 Jan 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_vision/trunk/interface/views/filename_view.e $"
	date:		"$Date: 2012-05-31 14:05:35 -0400 (Thu, 31 May 2012) $"
	revision:	"$Revision: 10 $"

class
	FILENAME_VIEW

inherit

	EV_VERTICAL_BOX
		rename
			object_id as ise_object_id
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end

	VIEW
		undefine
			copy,
			is_equal
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
			Precursor {EV_VERTICAL_BOX}
			create browse_button
			create directory_text
			create file_list
			browse_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_shell_color_buffer))
			browse_button.set_tooltip ("{FILENAME_VIEW.Browse_button")
		end

	initialize
			-- Create an editor view.
		do
			Precursor {EV_VERTICAL_BOX}
			Precursor {VIEW}
			extend (browse_button)
			extend (directory_text)
			extend (file_list)
			disable_item_expand (browse_button)
			disable_item_expand (directory_text)
			set_actions
		end

	set_actions
			-- Add actions to the widgets and view.
		do
			browse_button.select_actions.extend (agent on_browse_button_pressed)
			directory_text.change_actions.extend (agent on_directory_text_changed)
		end

feature {NONE} -- Actions

	on_browse_button_pressed
			-- React to a press of the browse button
		do
			directory_dialog.show_modal_to_window (parent_window)
		end

	on_directory_selected
			-- React to a directory selection from the `directory_dialog'.
		do
			directory_text.set_text (directory_dialog.directory)
		end

	on_directory_text_changed
			-- React to a change of the `directory_text'.
		do
			draw
		end

feature -- Basic operations

	draw
			-- Redraw the view
		local
			d: DIRECTORY
			lin: ARRAYED_LIST [STRING]
			s, ext: STRING
			i: EV_LIST_ITEM
			p: EV_PIXMAP
		do
			file_list.wipe_out
			create d.make_open_read (directory_text.text)
			if d.exists then
				lin := d.linear_representation
				from lin.start
				until lin.exhausted
				loop
					s := lin.item
					ext := s.twin
					ext.keep_tail (3)
					if equal (ext, "ico") or equal (ext, "png") then
						create p
						p.set_with_named_file (directory_dialog.directory + "\" + s)
						create i.make_with_text (s)
						i.set_pixmap (p)
						i.set_pebble (directory_dialog.directory + "\" + s)
						file_list.extend (i)
					end
					lin.forth
				end
			end
			d.close
		end

feature {NONE} -- Implementation

	browse_button: EV_BUTTON
			-- To open a directory dialog

	directory_text: EV_TEXT
			-- To display the directory (or path).

	file_list: EV_LIST
			-- To display the filenames of the files

	directory_dialog: EV_DIRECTORY_DIALOG
			-- The standard direcory selection dialog.
		once
			create Result
			Result.set_start_directory ("d:/eiffel54/studio/bitmaps/ico")
			Result.ok_actions.extend (agent on_directory_selected)
		end

end
