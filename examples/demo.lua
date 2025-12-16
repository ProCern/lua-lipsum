#!/usr/bin/env lua
-- lua-lipsum demonstration script
-- Run with: lua examples/demo.lua
-- Or via just: just example

-- Add src to package path for development
package.path = 'src/?.lua;src/?/init.lua;' .. package.path

local lipsum = require 'lipsum'

-- Helper to print a section header
local function header(title)
  print(string.rep('=', 60))
  print(title)
  print(string.rep('=', 60))
  print()
end

-- Helper to wrap text at a given width
local function wrap(text, width)
  width = width or 70
  local lines = {}
  local line = ''

  for word in text:gmatch('%S+') do
    if #line + #word + 1 > width then
      table.insert(lines, line)
      line = word
    elseif #line == 0 then
      line = word
    else
      line = line .. ' ' .. word
    end
  end

  if #line > 0 then
    table.insert(lines, line)
  end

  return table.concat(lines, '\n')
end

print()
print('  LUA-LIPSUM DEMONSTRATION')
print('  Lorem Ipsum Generator for Lua')
print()

-- Module info
header('Module Statistics')
print(string.format('Total words in source:     %d', lipsum.word_count()))
print(string.format('Total sentences in source: %d', lipsum.sentence_count()))
print()

-- Random words
header('Random Words')
print('lipsum.words(10) - Get 10 random words:')
print()
local words = lipsum.words(10)
print('  ' .. table.concat(words, ', '))
print()
print('Note: These can be joined with table.concat(words, " ")')
print()

-- Word clusters
header('Word Clusters')
print('lipsum.word_clusters(6, 3) - Get 3 clusters of 6 sequential words:')
print()
local clusters = lipsum.word_clusters(6, 3)
for i, cluster in ipairs(clusters) do
  print(string.format('  %d. %s', i, cluster))
end
print()
print('Word clusters preserve the original word sequence from the source.')
print()

-- Sentences
header('Random Sentences')
print('lipsum.sentences(3) - Get 3 random sentences:')
print()
local sentences = lipsum.sentences(3)
for i, sentence in ipairs(sentences) do
  print(string.format('%d. %s', i, wrap(sentence, 55)))
  print()
end

-- Paragraphs
header('Paragraphs')
print('lipsum.paragraphs(2, 3, 5) - Get 2 paragraphs with 3-5 sentences each:')
print()
local paragraphs = lipsum.paragraphs(2, 3, 5)
for i, para in ipairs(paragraphs) do
  print(string.format('Paragraph %d:', i))
  print(wrap(para, 60))
  print()
end

-- Generated text
header('Generated Text')
print('lipsum.text(75) - Generate ~75 words of formatted text:')
print()
print(wrap(lipsum.text(75), 60))
print()

-- Lorem ipsum classic
header('Classic Lorem Ipsum')
print('lipsum.lorem_ipsum(50) - Text from the famous "dolorem ipsum" passage:')
print()
print(wrap(lipsum.lorem_ipsum(50), 60))
print()

-- Practical example
header('Practical Example: HTML Placeholder')
print('Generating placeholder content for a webpage:')
print()
print('<article>')
print('  <h1>' .. table.concat(lipsum.words(4), ' '):gsub('^%l', string.upper) .. '</h1>')
print('  <p>')
print('    ' .. wrap(lipsum.text(40), 50):gsub('\n', '\n    '))
print('  </p>')
print('  <p>')
print('    ' .. wrap(lipsum.text(35), 50):gsub('\n', '\n    '))
print('  </p>')
print('</article>')
print()

-- Raw source preview
header('Source Text (First 300 characters)')
print('lipsum.source() - Access the original Latin text:')
print()
print(wrap(lipsum.source():sub(1, 300) .. '...', 60))
print()

print(string.rep('=', 60))
print('End of demonstration')
print(string.rep('=', 60))
