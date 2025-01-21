require("git"):setup()

-- not working
-- require("omp"):setup()

-- bookmarks manager
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
table.insert(bookmarks, {
  tag = "Desktop",
  path = home_path .. path_sep .. "Desktop" .. path_sep,
  key = "d"
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
-- end of bookmarks manager setup
--
-- projects: save/restore tabs
require("projects"):setup({
    save = {
        method = "lua", -- yazi | lua
        -- lua_save_path = "", -- windows: "%APPDATA%/yazi/state/projects.json", unix: "~/.config/yazi/state/projects.json"
    },
    last = {
        update_after_save = true,
        update_after_load = true,
        load_after_start = true,
    },
    merge = {
        quit_after_merge = false,
    },
    notify = {
        enable = true,
        title = "Projects",
        timeout = 2,
        level = "info",
    },
})
-- end projects: save/restore tabs
