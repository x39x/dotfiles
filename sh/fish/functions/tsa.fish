# Toggle System Appearance
function alat_theme
    set -l theme "$argv[1]"
    ln -sf $HOME/.config/alacritty/themes/{$theme}.toml $HOME/.local/state/user/alacritty.toml
end

function tsa
    set -l dir $HOME/.local/state/user
    set -l file "$dir/dark_mode"

    if not test -d $dir
        mkdir -p $dir
    end

    if test -f $file
        set current (cat $file)
        if test $current = "true"
            echo false > $file
            alat_theme "light"
        else
            echo true > $file
            alat_theme "dark"
        end
    else
        echo true > $file
        alat_theme "dark"
    end
end
