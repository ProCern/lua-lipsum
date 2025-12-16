# lua-lipsum task runner

# Default recipe: show available commands
default:
    @just --list

# Run all tests
test:
    busted spec/

# Run tests with verbose output
test-verbose:
    busted spec/ --verbose

# Run tests with coverage (requires luacov)
test-coverage:
    busted spec/ --coverage
    luacov
    @echo "Coverage report generated: luacov.report.out"

# Run the example script
example:
    lua examples/demo.lua

# Check Lua syntax (requires luacheck)
lint:
    luacheck src/ spec/ examples/ --no-unused-args

# Format code (requires lua-format or stylua)
format:
    stylua src/ spec/ examples/ || echo "stylua not found, skipping format"

# Install development dependencies
setup:
    @echo "Installing luarocks dependencies..."
    luarocks install busted --local
    luarocks install luacheck --local
    @echo "Done! Make sure ~/.luarocks/bin is in your PATH"

# Clean generated files
clean:
    rm -f luacov.stats.out luacov.report.out
    rm -rf .luacov

# Interactive Lua REPL with lipsum loaded
repl:
    lua -i -e "package.path='src/?.lua;src/?/init.lua;'..package.path; lipsum=require'lipsum'; print('lipsum module loaded')"

# Generate sample output
sample:
    @echo "=== Random Words (10) ==="
    @lua -e "package.path='src/?.lua;src/?/init.lua;'..package.path; local l=require'lipsum'; print(table.concat(l.words(10), ', '))"
    @echo ""
    @echo "=== Word Cluster (8 words) ==="
    @lua -e "package.path='src/?.lua;src/?/init.lua;'..package.path; local l=require'lipsum'; print(l.word_clusters(8, 1)[1])"
    @echo ""
    @echo "=== Random Sentences (3) ==="
    @lua -e "package.path='src/?.lua;src/?/init.lua;'..package.path; local l=require'lipsum'; for _,s in ipairs(l.sentences(3)) do print('- '..s) end"
    @echo ""
    @echo "=== Paragraph ==="
    @lua -e "package.path='src/?.lua;src/?/init.lua;'..package.path; local l=require'lipsum'; print(l.paragraphs(1)[1])"
    @echo ""
    @echo "=== Lorem Ipsum (50 words) ==="
    @lua -e "package.path='src/?.lua;src/?/init.lua;'..package.path; local l=require'lipsum'; print(l.lorem_ipsum(50))"
