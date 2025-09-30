require("git"):setup()

require("omp"):setup({config = "/home/praful/.config/oh-my-posh/pk-posh-theme.omp.json"})

------------------------------------------------------------
-- bookmarks manager
-- You can configure your bookmarks by lua language
local bookmarks = {}

local path_sep = package.config:sub(1, 1)
local home_path = ya.target_family() == "windows" and os.getenv("USERPROFILE") or os.getenv("HOME")
if ya.target_family() == "windows" then
  table.insert(bookmarks, {
    tag = "Scoop Local",
    
    path = (os.getenv("SCOOP") or home_path .. "\\scoop") .. "\\",
    key = "p"
  })
  table.insert(bookmarks, {
    tag = "Scoop Global",
    path = (os.getenv("SCOOP_GLOBAL") or "C:\\ProgramData\\scoop") .. "\\",
    key = "P"
  })
end
-- table.insert(bookmarks, {
--
  -- tag = "Desktop",
  -- path = home_path .. path_sep .. "Desktop" .. path_sep,
  -- key = "t"
-- })

table.insert(bookmarks, {
  tag = "Mounts",
  path = path_sep .. "mnt" .. path_sep,
  key = "m"
})

table.insert(bookmarks, {
  tag = "Public transfer",
  path = path_sep .. "mnt" .. path_sep .. "public" .. path_sep .. "transfer" .. path_sep,
  key = "t"
})

table.insert(bookmarks, {
  tag = "Dev projects",
  path = home_path .. path_sep .. "data" .. path_sep .. "dev" .. path_sep .. "projects" .. path_sep,
  key = "p"
})

table.insert(bookmarks, {
  tag = "Data",
  path = home_path .. path_sep .. "data" .. path_sep,
  key = "d"
})

table.insert(bookmarks, {
  tag = "scans",
  path = home_path .. path_sep .. "data" .. path_sep .. "scans" .. path_sep,
  key = "s"
})

table.insert(bookmarks, {
  tag = "Downloads",
  path = home_path .. path_sep .. "data" .. path_sep .. "downloads" .. path_sep,
  key = "w"
})

require("yamb"):setup {
  -- Optional, the path ending with path seperator represents folder.
  bookmarks = bookmarks,
  -- Optional, recieve notification everytime you jump.
  jump_notify = true,
  -- Optional, the cli of fzf.
  cli = "fzf",
  -- Optional, a string used for randomly generating keys, where the preceding characters have higher priority.
  keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  -- Optional, the path of bookmarks
  path = (ya.target_family() == "windows" and os.getenv("APPDATA") .. "\\yazi\\config\\bookmark") or
        (os.getenv("HOME") .. "/.config/yazi/bookmark"),
}

------------------------------------------------------------
---- projects
require("projects"):setup({
    save = {
        method = "lua", -- yazi | lua (must be lua to save on exit)
        yazi_load_event = "@projects-load", -- event name when loading projects in `yazi` method
        -- lua_save_path = "", -- path of saved file in `lua` method, comment out or assign explicitly
                            -- default value:
                            -- windows: "%APPDATA%/yazi/state/projects.json"
                            -- unix: "~/.local/state/yazi/projects.json"
    },
    last = {
        update_after_save = true,
        update_after_load = true,
        load_after_start = true,
    },
    merge = {
        event = "projects-merge",
        quit_after_merge = false,
    },
    event = {
        save = {
            enable = true,
            name = "project-saved",
        },
        load = {
            enable = true,
            name = "project-loaded",
        },
        delete = {
            enable = true,
            name = "project-deleted",
        },
        delete_all = {
            enable = true,
            name = "project-deleted-all",
        },
        merge = {
            enable = true,
            name = "project-merged",
        },
    },
    notify = {
        enable = true,
        title = "Projects",
        timeout = 3,
        level = "info",
    },
})
------------------------------------------------------------
-- built-in plugin that allows you to copy and paste between different instances 
require("session"):setup {
	sync_yanked = true,
}

-- to use for linemode in yazi.toml
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

------------------------------------------------------------
-- show symlink in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
