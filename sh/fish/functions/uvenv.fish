# cd ~/.pyVenv
# mkdir myvenv

# uv venv myvenv -p 3.15 
# 会把 myvenv 作为虚拟环境目录 ~/.pyVenv/myvenv/bin/activate.fish"

# cd myvenv && uv venv -p 3.15
# 会在 myenv 里新建 .venv 作为虚拟环境目录 ~/.pyVenv/myvenv/.venv/bin/activate.fish"

# uv pip install xxx / pip install xxx

function uvenv
    if set -q VIRTUAL_ENV
        if test (count $argv) -gt 0
            echo (set_color red)"Already in: "(basename $VIRTUAL_ENV)(set_color normal)
            return 1
        end

        set old_env (basename $VIRTUAL_ENV)
        deactivate
        echo (set_color yellow)"Deactivated: $old_env"(set_color normal)
        return
    end

    set env_name ".venv"
    set env_path ".venv/bin/activate.fish"

    if test (count $argv) -gt 0
        set env_name $argv[1]
        set env_path "$HOME/.pyVenv/$env_name/bin/activate.fish"
    end

    if test -f $env_path
        source $env_path
        echo (set_color green)"Activated: "(basename $VIRTUAL_ENV)(set_color normal)
    else
        echo (set_color red)"Not found: $env_name"(set_color normal)
        return 1
    end
end
