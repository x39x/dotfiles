-- https://docs.astral.sh/ty/modules/#python-environment
-- ty will attempt to discover a virtual environment.
return {
        cmd = { "uv", "run", "ty", "server" },
        filetypes = { "python" },
        root_markers = { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        on_init = function(client, _)
                client.server_capabilities.semanticTokensProvider = nil -- turn off semantic tokens
        end,
}
