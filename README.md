# lua-lipsum

A Lorem Ipsum generator for Lua, using the original Latin source text from Cicero's *De finibus bonorum et malorum* (45 BC).

## Installation

Copy the `src/lipsum` directory to your project or Lua path:

```bash
cp -r src/lipsum /path/to/your/project/
```

Or add `src/` to your `package.path`:

```lua
package.path = 'path/to/lua-lipsum/src/?.lua;path/to/lua-lipsum/src/?/init.lua;' .. package.path
```

## Usage

```lua
local lipsum = require 'lipsum'

-- Generate random words
local words = lipsum.words(10)
print(table.concat(words, ', '))
-- Output: plane, iusteque, in, dixit, An, invidus, habeat, amicitia, corpus, a

-- Generate word clusters (sequential words from source)
local clusters = lipsum.word_clusters(5, 2)
for _, cluster in ipairs(clusters) do
  print(cluster)
end
-- Output: philosophiae quidem vituperatoribus satis responsum
--         laudatum a ceteris ab hoc

-- Generate random sentences
local sentences = lipsum.sentences(2)
print(table.concat(sentences, ' '))

-- Generate paragraphs (3-7 sentences each by default)
local paragraphs = lipsum.paragraphs(2)
print(table.concat(paragraphs, '\n\n'))

-- Generate formatted text with approximate word count
local text = lipsum.text(100)
print(text)

-- Generate text from the famous "dolorem ipsum" passage
local classic = lipsum.lorem_ipsum(50)
print(classic)
```

## API Reference

### `lipsum.words(count)`

Returns a table of `count` random words (default: 1).

```lua
local words = lipsum.words(5)
-- Returns: {"cum", "non", "voluptatem", "esse", "diceret"}
```

### `lipsum.word_clusters(cluster_size, count)`

Returns a table of `count` clusters (default: 1), each containing `cluster_size` sequential words (default: 5) from the source text.

```lua
local clusters = lipsum.word_clusters(4, 2)
-- Returns: {"summis ingeniis exquisitaque doctrina", "dolor sit amet consectetur"}
```

### `lipsum.sentences(count)`

Returns a table of `count` random complete sentences (default: 1).

```lua
local sentences = lipsum.sentences(2)
-- Each sentence includes original punctuation
```

### `lipsum.paragraphs(count, min_sentences, max_sentences)`

Returns a table of `count` paragraphs (default: 1), each containing between `min_sentences` (default: 3) and `max_sentences` (default: 7) sentences.

```lua
local paragraphs = lipsum.paragraphs(3, 4, 6)
-- Returns 3 paragraphs with 4-6 sentences each
```

### `lipsum.text(count)`

Returns a single string of approximately `count` words (default: 50), formatted with proper capitalization and punctuation.

```lua
local text = lipsum.text(75)
-- Returns formatted lorem ipsum text
```

### `lipsum.lorem_ipsum(word_count)`

Returns text starting from the famous "dolorem ipsum" passage in the source (default: 50 words).

```lua
local classic = lipsum.lorem_ipsum(30)
-- Returns: "Dolorem ipsum per se esse fugiendum..."
```

### `lipsum.source()`

Returns the raw source text.

### `lipsum.word_count()`

Returns the total number of words in the source text.

### `lipsum.sentence_count()`

Returns the total number of sentences in the source text.

## Source Text

The source text is from Cicero's *De finibus bonorum et malorum* ("On the ends of good and evil"), a philosophical work written in 45 BC. This is the original text from which the famous "Lorem ipsum" placeholder text was derived in the 1500s.

The module includes text from all five books:
- Liber Primus (Book I)
- Liber Secundus (Book II)
- Liber Tertius (Book III)
- Liber Quartus (Book IV)
- Liber Quintus (Book V)

## Development

### Prerequisites

- Lua 5.1+
- [busted](https://github.com/lunarmodules/busted) (for testing)
- [just](https://github.com/casey/just) (task runner, optional)

### Running Tests

```bash
# With just
just test

# Or directly with busted
busted spec/
```

### Available Tasks

```bash
just              # Show available commands
just test         # Run all tests
just test-verbose # Run tests with verbose output
just example      # Run the demo script
just sample       # Quick output samples
just repl         # Interactive REPL with lipsum loaded
just lint         # Check code with luacheck
just setup        # Install dev dependencies
just clean        # Clean generated files
```

### Running the Demo

```bash
just example
# or
lua examples/demo.lua
```

## License

AGPL-3.0 - See [LICENSE](LICENSE) for details.
