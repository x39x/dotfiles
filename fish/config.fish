if status is-interactive

        abbr -a v     nvim 
        abbr -a g     git
        abbr -a gb    git branch
        abbr -a gk    git checkout
        abbr -a gt    git status
        abbr -a gs    git status
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

        set -x fish_greeting ""

        zoxide init fish  --cmd c | source

        fzf --fish | source
        bind \ec fzf-file-widget

end
