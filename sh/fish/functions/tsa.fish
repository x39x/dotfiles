# Toggle System Appearance


# alat_theme "light" / alat_theme "dark"
function alat_theme
    set -l theme "$argv[1]"
    ln -sf $HOME/.config/alacritty/themes/{$theme}.toml $HOME/.local/state/user/alacritty.toml
end

function tsa
    set -l dir $HOME/.local/state/matsu
    set -l mode "$dir/dark_mode"
    set -l vim_theme "$dir/colo.vim"

    if not test -d $dir
        mkdir -p $dir
    end

    if test -f $mode
        set current (cat $mode)
        if test $current = "true"
            echo false > $mode
            echo "colo 39light" > $vim_theme
        else
            echo true > $mode
            echo "colo $VIM_DARK_THEME" > $vim_theme
        end
    else
        echo false > $mode
        echo "colo 39light" > $vim_theme
    end
end
