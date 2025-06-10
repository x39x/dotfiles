import os
from pathlib import Path

from ln39 import File39, utils

base = [
    File39("vimrc", "~/.vimrc"),
    File39("tmux.conf", "~/.tmux.conf"),
    File39("screenrc", "~/.screenrc"),
    File39("fish", "~/.config/fish"),
    File39("sh/profile", "~/.profile"),
    File39("sh/bash_profile", "~/.bash_profile"),
    File39("sh/bashrc", "~/.bashrc"),
]


default = [
    File39("git", "~/.config/git"),
    File39("nvim", "~/.config/nvim"),
    File39("alacritty", "~/.config/alacritty"),
    File39("ghostty", "~/.config/ghostty"),
    File39("fdignore", "~/.config/fd/ignore"),
    File39("ripgrep/rgignore", "~/.rgignore"),
    File39("ripgrep/ripgreprc", "~/.config/ripgreprc"),
    File39("bat", "~/.config/bat/config"),
    File39(
        "lazygit.yml",
        utils.path_by_os(
            linux="~/.config/lazygit/config.yml",
            macos="~/Library/Application Support/lazygit/config.yml",
        ),
    ),
    File39(
        "clangd.yaml",
        utils.path_by_os(
            linux="~/.config/clangd/config.yaml",
            macos="~/Library/Preferences/clangd/config.yaml",
        ),
    ),
    File39("fmtstyle/clang-format", "~/.clang-format"),
    File39(
        "fmtstyle/rustfmt.toml",
        utils.path_by_os(
            linux="~/.config/rustfmt/rustfmt.toml",
            macos="~/Library/Application Support/rustfmt/rustfmt.toml",
        ),
    ),
    File39(
        "vscode/settings.json",
        utils.path_by_os(
            macos="~/Library/Application Support/Code/User/settings.json",
            linux="~/.config/Code/User/settings.json",
        ),
    ),
    File39(
        "vscode/keybindings.json",
        utils.path_by_os(
            macos="~/Library/Application Support/Code/User/keybindings.json",
            linux="~/.config/Code/User/keybindings.json",
        ),
    ),
]

linux=[
    File39("xkb", "~/.config/xkb"),
    File39("sway", "~/.config/sway"),
    File39("i3blocks", "~/.config/i3blocks"),
    File39("swaylock", "~/.config/swaylock"),
]

macos = [
    File39("sh/zshenv", "~/.zshenv"),
    File39("sh/zshrc", "~/.zshrc"),
    File39("hammerspoon", "~/.hammerspoon"),
    File39("karabiner", "~/.config/karabiner"),
]

# TODO: linux path
rime = [
    File39("Rime/default.custom.yaml", "~/Library/Rime/default.custom.yaml"),
    File39("Rime/squirrel.custom.yaml", "~/Library/Rime/squirrel.custom.yaml"),
    File39(
        "Rime/double_pinyin.custom.yaml", "~/Library/Rime/double_pinyin.custom.yaml"
    ),
]


def update_rime_repo():
    rime_url = "https://github.com/iDvel/rime-ice"
    rime_path = utils.path_by_os(
        macos="~/Library/Rime", linux="~/.local/share/fcitx/rime"
    )

    rime_path = Path(os.path.expanduser(rime_path))

    if rime_path.exists():
        print(f"[INFO] Path '{rime_path}' exists.")

        git_dir = rime_path / ".git"
        if git_dir.is_dir():
            print(f"[INFO] Pulling latest changes in: {rime_path}")
            utils.pull_repo(rime_path)
        else:
            print(
                f"[INFO] '{rime_path}' is not a Git repo. Backing up and re-cloning..."
            )
            utils.backup(rime_path)
            utils.clone_repo(rime_url, str(rime_path))
    else:
        print(f"[INFO] '{rime_path}' does not exist. Cloning repository...")
        utils.clone_repo(rime_url, str(rime_path))
    print()


# NOTE:
if utils.env_exists("BASE"):
    utils.ln(base)
    exit()

utils.ln(base)
utils.ln(default)
if utils.get_os_name() == "Darwin":
    utils.ln(macos)
if utils.get_os_name() == "Linux":
    utils.ln(linux)

if utils.env_exists("RIME"):
    update_rime_repo()
    utils.ln(rime)

utils.update_ln39()
