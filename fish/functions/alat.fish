function alat
        if test $TERM_PROGRAM = "alacritty"
                function theme
                        ln -sf $HOME/.config/alacritty/themes/{$argv[1]}.toml $HOME/.cache/alacritty.toml
                end

                set -l ALACRITTY_THEME (defaults read -g AppleInterfaceStyle 2>/dev/null; or echo "Light")

                if test "$ALACRITTY_THEME" = "Dark"
                        theme "39dark"
                else
                        theme "39light"
                end
        end
end
