local source = require 'lipsum._finibus'

-- Parse the source text to extract word and sentence boundaries
local function parse_source()
  local words = {}
  local sentences = {}

  local i = 1
  local len = #source
  local sentence_start = nil

  while i <= len do
    local char = source:sub(i, i)

    -- Skip whitespace and punctuation to find word start
    if char:match('[%a]') then
      local word_start = i
      -- Find word end
      while i <= len and source:sub(i, i):match('[%a]') do
        i = i + 1
      end
      local word_end = i - 1

      table.insert(words, { first = word_start, last = word_end })

      -- Track sentence start (first word after sentence end or at beginning)
      if sentence_start == nil then
        sentence_start = word_start
      end
    elseif char:match('[%.%?!]') then
      -- End of sentence
      if sentence_start then
        table.insert(sentences, { first = sentence_start, last = i })
        sentence_start = nil
      end
      i = i + 1
    else
      i = i + 1
    end
  end

  return words, sentences
end

local words, sentences = parse_source()

local module = {}

--- Get the raw source text
---@return string
function module.source()
  return source
end

--- Get the total number of words in the source
---@return integer
function module.word_count()
  return #words
end

--- Get the total number of sentences in the source
---@return integer
function module.sentence_count()
  return #sentences
end

--- Generate a table of words, picked at random.
--- These are not pre-joined, but can easily be passed into table.concat
---@param count? integer Number of words to generate (default: 1)
---@return string[]
function module.words(count)
  count = count or 1
  local result = {}

  for _ = 1, count do
    local idx = math.random(1, #words)
    local word = words[idx]
    table.insert(result, source:sub(word.first, word.last))
  end

  return result
end

--- Generate a table of sequential word clusters, picked at random.
--- Each cluster is a string of sequential words picked from the source,
--- with no punctuation or non-word characters between.
--- These are not pre-joined, but can easily be passed into table.concat.
---@param cluster_size? integer Number of words per cluster (default: 5)
---@param count? integer Number of clusters to generate (default: 1)
---@return string[]
function module.word_clusters(cluster_size, count)
  cluster_size = cluster_size or 5
  count = count or 1
  local result = {}

  for _ = 1, count do
    -- Pick a random starting word that allows for cluster_size words
    local max_start = math.max(1, #words - cluster_size + 1)
    local start_idx = math.random(1, max_start)

    local cluster_words = {}
    for j = 0, cluster_size - 1 do
      local word = words[start_idx + j]
      if word then
        table.insert(cluster_words, source:sub(word.first, word.last))
      end
    end

    table.insert(result, table.concat(cluster_words, ' '))
  end

  return result
end

--- Generate a table of sentences, picked at random.
--- These are not pre-joined, but can easily be passed into table.concat
---@param count? integer Number of sentences to generate (default: 1)
---@return string[]
function module.sentences(count)
  count = count or 1
  local result = {}

  for _ = 1, count do
    local idx = math.random(1, #sentences)
    local sentence = sentences[idx]
    table.insert(result, source:sub(sentence.first, sentence.last))
  end

  return result
end

--- Generate a table of paragraphs, each containing a random number of sentences.
--- These are not pre-joined, but can easily be passed into table.concat
---@param count? integer Number of paragraphs to generate (default: 1)
---@param min_sentences? integer Minimum sentences per paragraph (default: 3)
---@param max_sentences? integer Maximum sentences per paragraph (default: 7)
---@return string[]
function module.paragraphs(count, min_sentences, max_sentences)
  count = count or 1
  min_sentences = min_sentences or 3
  max_sentences = max_sentences or 7
  local result = {}

  for _ = 1, count do
    local sentence_count = math.random(min_sentences, max_sentences)
    local para_sentences = module.sentences(sentence_count)
    table.insert(result, table.concat(para_sentences, ' '))
  end

  return result
end

--- Generate lorem ipsum text with the specified number of words.
--- Returns a single string of approximately the requested word count.
---@param count? integer Approximate number of words (default: 50)
---@return string
function module.text(count)
  count = count or 50
  local result_words = module.words(count)

  -- Capitalize first word
  if #result_words > 0 then
    result_words[1] = result_words[1]:sub(1, 1):upper() .. result_words[1]:sub(2)
  end

  -- Add periods roughly every 8-15 words
  local text_parts = {}
  local sentence_length = math.random(8, 15)
  local word_count = 0

  for i, word in ipairs(result_words) do
    word_count = word_count + 1

    if word_count >= sentence_length and i < #result_words then
      -- End sentence
      table.insert(text_parts, word .. '.')
      word_count = 0
      sentence_length = math.random(8, 15)
      -- Capitalize next word
      if result_words[i + 1] then
        result_words[i + 1] = result_words[i + 1]:sub(1, 1):upper() .. result_words[i + 1]:sub(2)
      end
    else
      table.insert(text_parts, word)
    end
  end

  local text = table.concat(text_parts, ' ')

  -- Ensure text ends with a period
  if not text:match('%.$') then
    text = text .. '.'
  end

  return text
end

--- Generate the classic "Lorem ipsum dolor sit amet..." opening.
--- This finds and returns text starting from "Lorem ipsum" in the source.
---@param word_count? integer Number of words to include (default: 50)
---@return string
function module.lorem_ipsum(word_count)
  word_count = word_count or 50

  -- Find "Lorem" in the source (it doesn't exist in this classical text,
  -- so we'll generate from "Sed ut perspiciatis" which is another famous passage,
  -- or just return generated text prefixed with "Lorem ipsum dolor sit amet")

  -- The famous "Lorem ipsum" actually comes from a mangled version of this text
  -- Look for "dolorem ipsum" which is close to the origin
  local lorem_start = source:find('dolorem ipsum')

  if lorem_start then
    -- Find the word index closest to this position
    local start_word_idx = 1
    for i, word in ipairs(words) do
      if word.first >= lorem_start then
        start_word_idx = i
        break
      end
    end

    -- Extract words from this position
    local result = {}
    for i = start_word_idx, math.min(start_word_idx + word_count - 1, #words) do
      table.insert(result, source:sub(words[i].first, words[i].last))
    end

    local text = table.concat(result, ' ')
    -- Capitalize first letter
    text = text:sub(1, 1):upper() .. text:sub(2)

    -- Add period if needed
    if not text:match('[%.%?!]$') then
      text = text .. '.'
    end

    return text
  end

  -- Fallback to regular generated text
  return module.text(word_count)
end

return module
