---NOTE: https://github.com/Decodetalkers/neocmakelsp
---
--- Neovim does not currently include built-in snippets.
--- neocmakelsp only provides completions when snippet support is enabled.
--- To enable completion, install a snippet plugin and add the following override to your language client capabilities during setup.
return {
        cmd = { "neocmakelsp", "--stdio" },
        filetypes = { "cmake" },
        root_markers = { ".git", "build", "cmake" },
}
