# Toggle System Appearance
function alat_theme
    set -l dir ~/.cache/39sys
    set -l theme_file "$dir/alat_theme"
    set -l theme "$argv[1]"

    if test -f $theme_file
        set theme_cap (cat $theme_file)
        set theme "$theme_cap$argv[1]"
    end

    ln -sf $HOME/.config/alacritty/themes/{$theme}.toml $HOME/.cache/alacritty.toml
end

function tsa
    set -l dir ~/.cache/39sys
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
        alat_theme "39dark"
    end
end
