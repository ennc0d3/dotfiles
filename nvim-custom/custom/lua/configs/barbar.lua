local barbar = require("barbar")

barbar.setup({
  clickable = true,         -- Enables/disables clickable tabs
  tabpages = false,         -- Enable/disables current/total tabpages indicator (top right corner)
  insert_at_end = true,
  icons = {
    button = "",
    buffer_index = true,
    filetype = { enabled = true },
    visible = { modified = { buffer_number = false } },
    gitsigns = {
      added = { enabled = true, icon = "+" },
      changed = { enabled = true, icon = "~" },
      deleted = { enabled = true, icon = "-" }
    }
  }
})

