function fish_prompt --description 'Write out the prompt'
        set -g __fish_git_prompt_showuntrackedfiles true # take a lot of time
        set -g __fish_git_prompt_showdirtystate true
        set -g __fish_git_prompt_showstashstate true

        set -l last_status $status
        set -l normal_color (set_color normal)
        set -l status_color (set_color brblue)
        set -l cwd_color (set_color $fish_color_cwd)
        set -l vcs_color (set_color brpurple)
        set -l prompt_status ""

        # Since we display the prompt on a new line allow the directory names to be longer.
        set -q fish_prompt_pwd_dir_length
        or set -lx fish_prompt_pwd_dir_length 0

        set -l suffix '$ '
        # Color the prompt differently when we're root
        if functions -q fish_is_root_user; and fish_is_root_user
                if set -q fish_color_cwd_root
                        set cwd_color (set_color $fish_color_cwd_root)
                end
                set suffix '# '
        end

        # Color the prompt in red on error
        if test $last_status -ne 0
                set status_color (set_color $fish_color_error)
                set prompt_status $status_color "[" $last_status "]" $normal_color
        end

        echo -s (prompt_login)  ' ' $cwd_color (prompt_pwd) $vcs_color (fish_vcs_prompt) $normal_color ' ' $prompt_status
        echo -n -s $status_color $suffix $normal_color
end

function __postexec --on-event fish_postexec
        echo
end
