if status is-interactive

        abbr -a v     nvim 
        abbr -a g     git
        abbr -a gb    git branch
        abbr -a gk    git checkout
        abbr -a gt    git status
        abbr -a gd    git diff
        abbr -a ga    git add
        abbr -a gc    git commit -v 
        abbr -a gcm   git commit -m
        abbr -a gm    git merge
        abbr -a gr    git rebase
        abbr -a gl    git pull
        abbr -a glr   git pull --rebase -v
        abbr -a gf    git fetch
        abbr -a gp    git push
        abbr -a gg    git log --all --oneline --decorate --color --graph
        abbr -a grm   git remote -v

        zoxide init fish | source
        set -x fish_greeting ""

        set -gx FZF_CTRL_T_COMMAND
        fzf --fish | source

        function fish_user_key_bindings
                # bind -M default \en '__fzf_f'# meta: \eKEY,ctrl \cKEY
        end

end
