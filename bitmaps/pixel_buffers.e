note
	description: "[
		Images
		]"
	author: "Jimmy J. Johnson"
	date: "$Date: 2014-06-15 09:17:19 -0400 (Sun, 15 Jun 2014) $"
	revision: "$Revision: 18 $"

class
	PIXEL_BUFFERS

feature -- Access

	icon_back_color_buffer: ICON_BACK_COLOR  once  create Result.make  end

	icon_forth_color_buffer: ICON_FORTH_COLOR
		once
			create Result.make
		end

	icon_new_supplier_color_buffer: ICON_NEW_SUPPLIER_COLOR  once  create Result.make  end
	icon_delete_color_buffer: ICON_DELETE_COLOR  once  create Result.make  end
	icon_object_symbol_buffer: ICON_OBJECT_SYMBOL  once  create Result.make  end
	icon_new_class_color_buffer: ICON_NEW_CLASS_COLOR  once  create Result.make  end
	icon_open_file_color_buffer: ICON_OPEN_FILE_COLOR  once  create Result.make  end
	icon_save_color_buffer: ICON_SAVE_COLOR  once  create Result.make  end
	icon_undo_color_buffer: ICON_UNDO_COLOR  once  create Result.make  end
	icon_redo_color_buffer: ICON_REDO_COLOR  once  create Result.make  end
	icon_restore_color_buffer: ICON_RESTORE_COLOR  once  create Result.make  end
	icon_maximize_color_buffer: ICON_MAXIMIZE_COLOR  once  create Result.make  end
	icon_minimize_all_color_buffer: ICON_MINIMIZE_ALL_COLOR  once  create Result.make  end
	icon_restore_all_color_buffer: ICON_RESTORE_ALL_COLOR  once  create Result.make  end
	icon_close_color_buffer: ICON_CLOSE_COLOR  once  create Result.make  end
	icon_format_text_color_buffer: ICON_FORMAT_TEXT_COLOR  once  create Result.make  end
	icon_new_development_tool_color_buffer: ICON_NEW_DEVELOPMENT_TOOL_COLOR  once  create Result.make  end
	icon_folders_color_buffer: ICON_FOLDERS_COLOR  once  create Result.make  end
	icon_help_tool_color_buffer: ICON_HELP_TOOL_COLOR  once  create Result.make  end
	icon_shell_color_buffer: ICON_SHELL_COLOR  once  create Result.make  end
	icon_zoom_in_color_buffer: ICON_ZOOM_IN_COLOR  once  create Result.make  end
	icon_zoom_out_color_buffer: ICON_ZOOM_OUT_COLOR  once  create Result.make  end
	icon_supplier_color_buffer: ICON_SUPPLIER_COLOR  once  create Result.make  end

	icon_edit_expression_color_buffer: ICON_EDIT_EXPRESSION_COLOR once  create Result.make  end
	icon_tool_color_buffer: ICON_TOOL_COLOR  once  create Result.make  end
	icon_reset_diagram_color_buffer: ICON_RESET_DIAGRAM_COLOR  once create Result.make end
	icon_check_exports_color_buffer: ICON_CHECK_EXPORTS_COLOR  once create Result.make end

	Icon_bparrow_color_buffer: ICON_BPARROW_COLOR  once create Result.make end
	Icon_client_link_buffer: CLIENTLNK  once create Result.make end

	icon_auto_slice_limits_color_buffer: ICON_AUTO_SLICE_LIMITS_COLOR  once create Result.make end
	icon_format_exporteds_color_buffer: ICON_FORMAT_EXPORTEDS_COLOR  once create Result.make end
end
