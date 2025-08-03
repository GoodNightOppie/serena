# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

**Essential Commands (use these exact commands):**
- `uv run poe format` - Format code (BLACK + RUFF) - ONLY allowed formatting command
- `uv run poe type-check` - Run mypy type checking - ONLY allowed type checking command  
- `uv run poe test` - Run tests with default markers (excludes java/rust by default)
- `uv run poe lint` - Check code style without fixing

**Test Execution:**
- `uv run poe test -m "python"` - Run specific language tests (python, go, java, rust, typescript, php, csharp, elixir, terraform, clojure)
- `uv run poe test -m "snapshot"` - Run symbolic editing operation tests
- `uv run python -m pytest test/path/to/test_file.py::TestClass::test_method` - Run single test
- `uv run python -m pytest -k "pattern"` - Run tests matching pattern

**Serena CLI:**
- `uv run serena-mcp-server` - Start MCP server
- `uv run serena tools list` - List all available tools
- `uv run serena project list` - List projects
- `uv run serena context list` - List contexts
- `uv run serena mode list` - List modes
- `uv run index-project [path]` - Index project for faster tool performance

**Always run format, type-check, and test before completing any task.**

## Architecture Overview

Serena is a dual-layer coding agent toolkit that bridges Language Server Protocol (LSP) capabilities with AI agent interactions through the Model Context Protocol (MCP).

### Core Components

**1. SerenaAgent (`src/serena/agent.py`)**
- Central orchestrator managing projects, tools, and user interactions
- Handles tool registry, context/mode configurations, and memory management
- Manages language server lifecycle through task queue in separate thread
- Tracks file read history and tool usage statistics

**2. SolidLanguageServer (`src/solidlsp/ls.py`)**  
- Synchronous wrapper around Language Server Protocol implementations
- Provides unified interface for symbol operations across languages
- Implements caching layer to reduce language server overhead
- Handles automatic language server restart on crashes
- Manages file buffers and change tracking

**3. Tool System (`src/serena/tools/`)**
- **file_tools.py** - File operations, pattern search with gitignore support
- **symbol_tools.py** - Symbol finding by name/path, references, editing
- **memory_tools.py** - Markdown-based project knowledge persistence
- **config_tools.py** - Project activation, mode switching, config display
- **workflow_tools.py** - Onboarding, task summarization, instructions
- **cmd_tools.py** - Shell command execution with working directory management
- **jetbrains_tools.py** - Optional JetBrains IDE integration

**4. Configuration System (`src/serena/config/`)**
- **Contexts** - Tool sets for environments (desktop-app, agent, ide-assistant)
- **Modes** - Behavioral patterns (planning, editing, interactive, one-shot)
- **Projects** - Language server configs, ignored paths, read-only settings

### Language Support Architecture

Each supported language has:
1. **Language Server Implementation** in `src/solidlsp/language_servers/`
   - Inherits from base language server class
   - Handles language-specific initialization and configuration
   - May download runtime dependencies on first use
2. **Test Repository** in `test/resources/repos/<language>/test_repo/`
   - Contains realistic code examples for testing
   - Includes various symbol types and relationships
3. **Test Suite** in `test/solidlsp/<language>/`
   - Tests basic operations, symbol retrieval, references
   - Uses pytest markers for language-specific execution

### Memory & Knowledge System

- **Storage** - Markdown files in `.serena/memories/` within project
- **Onboarding** - Automatic project analysis on first activation
- **Retrieval** - Tools read specific memories on demand
- **Management** - Create, read, list, delete operations available

## Key Implementation Details

### Symbol Operations
- **Symbol Paths** - Use dot notation for nested symbols (e.g., `MyClass.my_method`)
- **Name Paths** - Full qualified names including parent symbols
- **References** - Find all usages of a symbol across the codebase
- **Editing** - Precise symbol-level modifications without line counting

### File Operations
- **Gitignore Support** - Respects `.gitignore` patterns in searches
- **Pattern Search** - Uses ripgrep-style regex patterns
- **Path Handling** - All paths relative to project root
- **Change Tracking** - Monitors which files have been read/modified

### Error Handling
- **Language Server Crashes** - Automatic restart and retry
- **File Conflicts** - Detects concurrent modifications
- **Tool Failures** - Graceful degradation with informative errors
- **Async Safety** - Task queue ensures sequential tool execution

## Configuration Hierarchy

1. **Command-line arguments** to `serena-mcp-server`
2. **Project-specific** `.serena/project.yml`
3. **User config** `~/.serena/serena_config.yml`
4. **Active modes and contexts** (runtime modifiers)

## Development Guidelines

### Code Style
- **Python 3.11** - Type hints required for all functions
- **Line length** - 140 characters maximum
- **Imports** - Organized by ruff, absolute imports preferred
- **Docstrings** - Not required for all methods (D100-D107 ignored)
- **Testing** - Write tests for new functionality

### Adding New Features
1. **New Language Support** - See CONTRIBUTING.md for detailed steps
2. **New Tools** - Inherit from Tool base class, implement apply method
3. **New Modes/Contexts** - Add YAML files to config directories
4. **Configuration** - Update templates and migration logic

### Performance Considerations
- **Language Server Caching** - Reuse symbol lookups when possible
- **File Reading** - Track read history to avoid redundant reads
- **Pattern Search** - Use indexed search when available
- **Async Operations** - MCP server uses asyncio, agent uses threads

### Common Pitfalls
- **Path Handling** - Always use relative paths from project root
- **Symbol Editing** - Verify symbol exists before attempting edits
- **Language Server State** - May need restart after external changes
- **Memory Conflicts** - Avoid duplicate memory names across projects