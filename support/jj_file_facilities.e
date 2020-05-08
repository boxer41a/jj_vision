note
	description: "[
		Facilities for verifying file names, extensions, paths, directores, etc."
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_support/trunk/jj_other/jj_file_facilities.e $"
	date:		"$Date: 2014-12-31 09:42:58 -0800 (Wed, 31 Dec 2014) $"
	revision:	"$Revision: 53 $"

class
	JJ_FILE_FACILITIES

feature -- Access

	Default_program_path: PATH
			-- The path name of directory where the system thinks its executable is located.
			-- The default is the directory from where the program was launched.
		once
			create Result.make_current
		end

	Default_data_path: PATH
			-- The name of the directory where data objects will be persisted.
		once
--			create Result.make_from_string (Default_program_path.name + "/jj_data/data.txt")
			create Result.make_from_string ("localhost")
		end

	Default_settings_path: PATH
			-- The name of the directory where program settings will be persisted
		once
			create Result.make_from_string (Default_program_path.name + "//jj_settings/settings.dat")
		end

feature -- Querry

	is_valid_file_name (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid file name?
		require
			name_exists: a_name /= Void
		local
			fn: FILE_NAME
		do
			if not a_name.is_empty then
				create fn.make_from_string (a_name)
				Result := fn.is_valid
--				if fn.is_valid then
--						-- Get the last character from the FILE_NAME.  Must convert to a STRING
--						-- because features `item' and `count' are not exported from FILE_NAME.
--					c := a_name.string.item (a_name.string.count)
--					Result := is_name_consistent (a_name) and then (c /= '/' and c /= '\')
--				end
			end
		end

	is_valid_directory_name (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid dirrectory name?
		require
			name_exists: a_name /= Void
		local
			dn: DIRECTORY_NAME
		do
			if not a_name.is_empty then
				create dn.make_from_string (a_name)
				Result := dn.is_valid
--				if fn.is_valid then
--						-- Get the last character from the FILE_NAME.  Must convert to a STRING
--						-- because features `item' and `count' are not exported from FILE_NAME.
--					c := a_name.string.item (a_name.string.count)
--					Result := is_name_consistent (a_name) and then (c /= '/' and c /= '\')
--				end
			end
		end

	is_valid_name (a_name: STRING): BOOLEAN
			-- Is `a_name' a consistent file or path name?
			-- `A_name' cannot contain the characters *?"<>|.
			-- It can only contain a colon, :, as the second character if it has a drive letter.
			-- It can only contain the same slashes, either / or \, not both.
		require
			name_exists: a_name /= Void
			name_not_empty: not a_name.is_empty
		do
			Result := is_valid_file_name (a_name) or else is_valid_directory_name (a_name)
--			Result := not a_name.has ('*') and then
--						not a_name.has ('?') and then
--						not a_name.has ('"') and then
--						not a_name.has ('<') and then
--						not a_name.has ('>') and then
--						not a_name.has ('|') and then
--						not (a_name.has ('\') and then a_name.has ('/')) and then
--						not (a_name.has ('/') and then a_name.has ('\')) and then
--						((not (a_name.occurrences (':') > 1)) and then
--						((a_name.occurrences (':') = 1 and then a_name.item (2) = ':' and then a_name.item (1).is_alpha) or else
--						a_name.occurrences (':') = 0))
		end

	is_mergeable (a_path_name: STRING; a_file_name: STRING): BOOLEAN
			-- Is `a_path_name' and `a_file_name' mergeable?
		require
			path_name_exists: a_path_name /= Void
			file_name_exists: a_file_name /= Void
		local
			o: OPERATING_ENVIRONMENT
			s: STRING
			f: FILE_NAME
		do
			create o
			s := a_path_name.string + separator + a_file_name.string
			create f.make_from_string (s)
			Result := is_valid_name (f)
		end

	file_exists (a_name: FILE_NAME): BOOLEAN
			-- Does a file or directory with name `a_name' exist?
			-- `A_name' should include the full path.
		require
			file_name_exists: a_name /= Void
			valid_name: is_valid_file_name (a_name)
		do
				-- Use a RAW_FILE just to check existence; the file
				-- will not be read or changed here.
			Result := (create {RAW_FILE}.make_with_name (a_name)).exists
		end

feature {NONE} -- Implementation

	separator: STRING
			-- Separator used by the operating environment
		do
			Result := (create {OPERATING_ENVIRONMENT}).directory_separator.out
		end

--	portable_file_name (fn: STRING): FILE_NAME is
--			-- Portable file name representation of `fn'
--		require
--			file_name_exists: fn /= Void
--			file_name_not_empty: not fn.is_empty
--			file_name_consistent: is_name_consistent (fn)
--		local
--			sep: CHARACTER
--			abs: BOOLEAN
--			s: STRING
--			sub: STRING
--			drv: STRING
--			pos: INTEGER
--			o: OPERATING_ENVIRONMENT
--		do
--			create Result.make
--			create o
--			s := clone (fn)
--			sep := separator (s)
--
--			if s.has (':') then
--				drv := s.substring (1, 2)
--				if Result.is_volume_name_valid (drv) then
--					Result.set_volume (drv)
--				end
--				s.keep_tail (s.count - 2)
--			end
--
--			if s @ 1 = sep then
--				abs := True
--			end
--
--			if abs then
--				pos := s.index_of (sep, 2)
--				if pos > 1 then
--					Result.set_directory (s.substring (2, pos - 1))
--					s.keep_tail (s.count - pos)
--				end
--			end
--
--			from
--			until
--				not s.has (sep)
--			loop
--				from
--				until
--					s.is_empty or else s @ 1 /= sep
--				loop
--					s.keep_tail (s.count - 1)
--				end
--				
--				pos := s.index_of (sep, 1)
--				sub := s.substring (1, pos - 1)
--				Result.extend (sub)
--				s.keep_tail (s.count - pos)
--			end
--			
--			if s.has ('.') then
--				pos := s.index_of ('.', 1)
--				Result.set_file_name (s.substring (1, pos - 1))
--				Result.add_extension (s.substring (pos + 1, s.count))
--			elseif not s.is_empty then
--				Result.set_file_name (s)
--			end
--		end

	merged_file_name (a_path_name: STRING; a_file_name: STRING): STRING
			-- File name merged from `a_path_name' and file name `a_file_name'
		require
			path_name_exists: a_path_name /= Void
			file_name_exists: a_file_name /= Void
			mergeable: is_mergeable (a_path_name, a_file_name)
		local
			s: STRING
		do
			s := a_path_name.string + separator + a_file_name.string
			create Result.make_from_string (s)
		ensure
			result_valid: is_valid_file_name (Result)
		end

end
