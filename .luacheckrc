-- luacheck configuration for lua-lipsum

std = 'lua51+lua52+lua53+lua54'

-- Globals defined by busted
files['spec/**/*.lua'] = {
  std = '+busted',
}

-- Allow long lines in source data
files['src/lipsum/_source.lua'] = {
  max_line_length = false,
}

-- Ignore unused loop variables
ignore = {
  '212', -- Unused argument (for _ in loops)
}

-- Max line length
max_line_length = 120
