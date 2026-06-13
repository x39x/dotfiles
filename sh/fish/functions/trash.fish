function trash

    if test (count $argv) -eq 0
        echo "Usage:"
        echo "  trash <file1> <file2> ..."
        echo "  trash -c  # clear trash"
        return 1
    end

    if string match -q "Darwin" (uname -s)

        if test (count $argv) -eq 1 -a $argv[1] = "-c"
            osascript -e 'tell application "Finder" to empty the trash'
            echo "Trash cleared."
            return 0
        end

        # use system trash
        command trash $argv
        return $status
    end

    set -l TRASH_DIR "$HOME/.local/Trash"

    if not test -d $TRASH_DIR
        mkdir -p $TRASH_DIR
    end

    # clear
    if test (count $argv) -eq 1 -a $argv[1] = "-c"
        rm -rf $TRASH_DIR/*
        echo "Trash cleared."
        return 0
    end

    # mv
    for f in $argv
        if not test -e $f
            echo "trash: file not found: $f"
            continue
        end

        set fname (basename $f)
        set ts (date "+%Y%m%d-%H%M%S")
        set target "$TRASH_DIR/$fname.$ts"

        mv $f $target
        echo "Moved $f -> $target"
    end
end
