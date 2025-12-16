-- The original text source for Lorem Ipsum, with all non-ascii characters trimmed out or replaced.  From https://la.wikisource.org/wiki/De_finibus_bonorum_et_malorum

return table.concat({
  require('lipsum._primus'),
  require('lipsum._secundus'),
  require('lipsum._tertius'),
  require('lipsum._quartus'),
  require('lipsum._quintus'),
}, ' ')
