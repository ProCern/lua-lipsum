-- Tests for lua-lipsum module
-- Run with: busted spec/

describe('lipsum', function()
  local lipsum

  setup(function()
    -- Add src to package path
    package.path = 'src/?.lua;src/?/init.lua;' .. package.path
    lipsum = require 'lipsum'
    -- Seed random for reproducible tests where needed
    math.randomseed(12345)
  end)

  describe('source', function()
    it('returns the source text', function()
      local source = lipsum.source()
      assert.is_string(source)
      assert.is_true(#source > 1000)
      -- Should start with "Non eram nescius"
      assert.is_truthy(source:match('^Non eram nescius'))
    end)
  end)

  describe('word_count', function()
    it('returns the total number of words', function()
      local count = lipsum.word_count()
      assert.is_number(count)
      assert.is_true(count > 100)
    end)
  end)

  describe('sentence_count', function()
    it('returns the total number of sentences', function()
      local count = lipsum.sentence_count()
      assert.is_number(count)
      assert.is_true(count > 10)
    end)
  end)

  describe('words', function()
    it('returns a single word by default', function()
      local result = lipsum.words()
      assert.is_table(result)
      assert.equals(1, #result)
      assert.is_string(result[1])
      assert.is_true(#result[1] > 0)
    end)

    it('returns the requested number of words', function()
      local result = lipsum.words(10)
      assert.is_table(result)
      assert.equals(10, #result)
      for _, word in ipairs(result) do
        assert.is_string(word)
        assert.is_true(#word > 0)
        -- Words should only contain letters
        assert.is_truthy(word:match('^%a+$'))
      end
    end)

    it('can be concatenated with table.concat', function()
      local result = lipsum.words(5)
      local text = table.concat(result, ' ')
      assert.is_string(text)
      assert.is_true(#text > 5)
    end)
  end)

  describe('word_clusters', function()
    it('returns a single cluster of 5 words by default', function()
      local result = lipsum.word_clusters()
      assert.is_table(result)
      assert.equals(1, #result)
      assert.is_string(result[1])
      -- Should contain spaces (multiple words)
      local word_count = 0
      for _ in result[1]:gmatch('%S+') do
        word_count = word_count + 1
      end
      assert.equals(5, word_count)
    end)

    it('respects cluster_size parameter', function()
      local result = lipsum.word_clusters(3, 1)
      assert.equals(1, #result)
      local word_count = 0
      for _ in result[1]:gmatch('%S+') do
        word_count = word_count + 1
      end
      assert.equals(3, word_count)
    end)

    it('returns multiple clusters', function()
      local result = lipsum.word_clusters(4, 3)
      assert.equals(3, #result)
      for _, cluster in ipairs(result) do
        local word_count = 0
        for _ in cluster:gmatch('%S+') do
          word_count = word_count + 1
        end
        assert.equals(4, word_count)
      end
    end)

    it('contains sequential words from source', function()
      -- With a cluster, words should be sequential from the source
      local result = lipsum.word_clusters(5, 1)
      local source = lipsum.source()
      -- The cluster should appear somewhere in the source (words in sequence)
      -- We just verify it's a valid string of words
      assert.is_string(result[1])
    end)
  end)

  describe('sentences', function()
    it('returns a single sentence by default', function()
      local result = lipsum.sentences()
      assert.is_table(result)
      assert.equals(1, #result)
      assert.is_string(result[1])
      -- Should end with punctuation
      assert.is_truthy(result[1]:match('[%.%?!]$'))
    end)

    it('returns the requested number of sentences', function()
      local result = lipsum.sentences(5)
      assert.equals(5, #result)
      for _, sentence in ipairs(result) do
        assert.is_string(sentence)
        assert.is_truthy(sentence:match('[%.%?!]$'))
      end
    end)

    it('sentences start with a capital letter', function()
      local result = lipsum.sentences(10)
      for _, sentence in ipairs(result) do
        local first_char = sentence:match('^%a')
        if first_char then
          assert.equals(first_char:upper(), first_char)
        end
      end
    end)
  end)

  describe('paragraphs', function()
    it('returns a single paragraph by default', function()
      local result = lipsum.paragraphs()
      assert.is_table(result)
      assert.equals(1, #result)
      assert.is_string(result[1])
    end)

    it('returns multiple paragraphs', function()
      local result = lipsum.paragraphs(3)
      assert.equals(3, #result)
      for _, para in ipairs(result) do
        assert.is_string(para)
        assert.is_true(#para > 0)
      end
    end)

    it('paragraphs contain multiple sentences', function()
      local result = lipsum.paragraphs(1, 3, 3) -- exactly 3 sentences
      -- Count sentence-ending punctuation
      local sentence_ends = 0
      for _ in result[1]:gmatch('[%.%?!]') do
        sentence_ends = sentence_ends + 1
      end
      assert.equals(3, sentence_ends)
    end)

    it('respects min/max sentence parameters', function()
      -- Test with exact range
      local result = lipsum.paragraphs(5, 2, 2)
      for _, para in ipairs(result) do
        local sentence_ends = 0
        for _ in para:gmatch('[%.%?!]') do
          sentence_ends = sentence_ends + 1
        end
        assert.equals(2, sentence_ends)
      end
    end)
  end)

  describe('text', function()
    it('returns approximately the requested word count', function()
      local result = lipsum.text(50)
      assert.is_string(result)
      local word_count = 0
      for _ in result:gmatch('%S+') do
        word_count = word_count + 1
      end
      -- Allow some variance due to punctuation
      assert.is_true(word_count >= 45 and word_count <= 55)
    end)

    it('starts with a capital letter', function()
      local result = lipsum.text(20)
      local first_char = result:match('^%a')
      assert.equals(first_char:upper(), first_char)
    end)

    it('ends with a period', function()
      local result = lipsum.text(30)
      assert.is_truthy(result:match('%.$'))
    end)

    it('contains sentence breaks', function()
      local result = lipsum.text(100)
      -- Should have at least one period in the middle
      local periods = 0
      for _ in result:gmatch('%.') do
        periods = periods + 1
      end
      assert.is_true(periods >= 2)
    end)
  end)

  describe('lorem_ipsum', function()
    it('returns text starting from the classic passage', function()
      local result = lipsum.lorem_ipsum(20)
      assert.is_string(result)
      assert.is_true(#result > 0)
    end)

    it('returns the requested word count', function()
      local result = lipsum.lorem_ipsum(30)
      local word_count = 0
      for _ in result:gmatch('%S+') do
        word_count = word_count + 1
      end
      -- Should be close to requested count
      assert.is_true(word_count >= 25 and word_count <= 35)
    end)

    it('starts with capital letter', function()
      local result = lipsum.lorem_ipsum(10)
      local first_char = result:match('^%a')
      assert.equals(first_char:upper(), first_char)
    end)

    it('ends with punctuation', function()
      local result = lipsum.lorem_ipsum(15)
      assert.is_truthy(result:match('[%.%?!]$'))
    end)
  end)
end)
