import os
from pathlib import Path

from ln39 import M, utils

base = [
    M("vimrc", "~/.vimrc"),
    M("tmux.conf", "~/.tmux.conf"),
    M("screenrc", "~/.screenrc"),
    M("fish", "~/.config/fish"),
    M("sh/profile", "~/.profile"),
    M("sh/bash_profile", "~/.bash_profile"),
    M("sh/bashrc", "~/.bashrc"),
]


default = [
    M("git", "~/.config/git"),
    M("nvim", "~/.config/nvim"),
    M("alacritty", "~/.config/alacritty"),
    M("ghostty", "~/.config/ghostty"),
    M("fdignore", "~/.config/fd/ignore"),
    M("ripgrep/rgignore", "~/.rgignore"),
    M("ripgrep/ripgreprc", "~/.config/ripgreprc"),
    M("bat", "~/.config/bat/config"),
    M(
        "lazygit.yml",
        utils.path_by_os(
            linux="~/.config/lazygit/config.yml",
            macos="~/Library/Application Support/lazygit/config.yml",
        ),
    ),
    M(
        "clangd.yaml",
        utils.path_by_os(
            linux="~/.config/clangd/config.yaml",
            macos="~/Library/Preferences/clangd/config.yaml",
        ),
    ),
    M("fmtstyle/clang-format", "~/.clang-format"),
    M(
        "fmtstyle/rustfmt.toml",
        utils.path_by_os(
            linux="~/.config/rustfmt/rustfmt.toml",
            macos="~/Library/Application Support/rustfmt/rustfmt.toml",
        ),
    ),
    M(
        "vscode/settings.json",
        utils.path_by_os(
            macos="~/Library/Application Support/Code/User/settings.json",
            linux="~/.config/Code/User/settings.json",
        ),
    ),
    M(
        "vscode/keybindings.json",
        utils.path_by_os(
            macos="~/Library/Application Support/Code/User/keybindings.json",
            linux="~/.config/Code/User/keybindings.json",
        ),
    ),
    M(
        "mpv",
        "~/.config/mpv",
    ),
]

linux = [
    M("xkb", "~/.config/xkb"),
    M("sway", "~/.config/sway"),
    M("i3blocks", "~/.config/i3blocks"),
    M("swaylock", "~/.config/swaylock"),
    M("tofi", "~/.config/tofi"),
    M("imv", "~/.config/imv"),
    M("swappy", "~/.config/swappy"),
    M("fontconfig", "~/.config/fontconfig"),
]

macos = [
    M("sh/zshenv", "~/.zshenv"),
    M("sh/zshrc", "~/.zshrc"),
    M("hammerspoon", "~/.hammerspoon"),
    M("karabiner", "~/.config/karabiner"),
]

rime = [
    M(
        "IM/Rime/default.custom.yaml",
        utils.path_by_os(
            macos="~/Library/Rime/default.custom.yaml",
            linux="~/.local/share/fcitx5/rime/default.custom.yaml",
        ),
    ),
    M(
        "IM/Rime/double_pinyin.custom.yaml",
        utils.path_by_os(
            macos="~/Library/Rime/double_pinyin.custom.yaml",
            linux="~/.local/share/fcitx5/rime/double_pinyin.custom.yaml",
        ),
    ),
    M(
        "IM/Rime/squirrel.custom.yaml",
        "~/Library/Rime/squirrel.custom.yaml",
        enabled=utils.get_os_name() == "Darwin",
    ),
    M("IM/fcitx5", "~/.config/fcitx5", enabled=utils.get_os_name() == "Linux"),
    M(
        "IM/fcitx5_themes",
        "~/.local/share/fcitx5/themes",
        enabled=utils.get_os_name() == "Linux",
    ),
]


def update_rime_repo():
    rime_url = "https://github.com/iDvel/rime-ice"
    rime_path = utils.path_by_os(
        macos="~/Library/Rime", linux="~/.local/share/fcitx5/rime"
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
