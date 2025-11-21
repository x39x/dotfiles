function trash
    set -l TRASH_DIR "$HOME/.Trash"

    # 如果目录不存在就创建
    if not test -d $TRASH_DIR
        mkdir -p $TRASH_DIR
    end

    # clear
    if test (count $argv) -eq 1
        switch $argv[1]
            case "-c" "--clear"
                echo "Clearing trash: $TRASH_DIR"
                rm -rf $TRASH_DIR/*
                echo "Trash cleared."
                return 0
        end
    end

    # no arg
    if test (count $argv) -eq 0
        echo "Usage:"
        echo "  trash <file1> <file2> ..."
        echo "  trash -c | --clear   # clear trash"
        return 1
    end

    # 逐个移动到废纸篓
    for f in $argv
        if not test -e $f
            echo "trash: file not found: $f"
            continue
        end

        # 防止重名
        set fname (basename $f)
        set ts (date "+%Y%m%d-%H%M%S")
        set target "$TRASH_DIR/$fname.$ts"

        mv $f $target
        echo "Moved $f -> $target"
    end
end
