function fish_greeting --description 'Rainbow band / text / rainbow band greeting'
    # `--demo` forces the animation even when not interactive (for previewing).
    set -l demo 0
    test "$argv[1]" = --demo; and set demo 1

    # On a non-interactive / dumb terminal, just print a plain line and bail.
    if test $demo -eq 0
        if not status is-interactive; or not isatty stdout; or test "$TERM" = dumb
            echo "welcome back, "(whoami)
            return
        end
    end

    # --- tunables ---
    set -l band 2        # rows in each rainbow band (top and bottom)
    set -l frames 18     # animation length
    set -l step 2        # palette shift per frame (wave speed)
    set -l tilt 2        # palette shift per row (diagonal steepness)
    set -l palette_n 30  # colors per rainbow cycle
    set -l delay 0.025   # seconds between frames

    set -l cols $COLUMNS
    test -n "$cols"; or set cols 80
    test "$cols" -gt 160; and set cols 160   # cap work on very wide terminals

    # Text lives between the bands; the diagonal flows past it.
    set -l user (whoami)
    set -l dt (date '+%Y-%m-%d %H:%M:%S')

    # battery meter (graceful if there's no battery)
    set -l cap ""
    set -l bstat ""
    for bdir in /sys/class/power_supply/BAT*
        test -r $bdir/capacity; or continue
        set cap (cat $bdir/capacity)
        test -r $bdir/status; and set bstat (string lower -- (cat $bdir/status))
        break
    end

    set -l line3 $dt
    if test -n "$cap"
        set -l segs 10
        set -l filled (math "round($cap / 100 * $segs)")
        test $filled -gt $segs; and set filled $segs
        test $filled -lt 0; and set filled 0
        set -l bar ""
        for i in (seq $segs)
            if test $i -le $filled
                set bar "$bar█"
            else
                set bar "$bar░"
            end
        end
        set line3 "$dt   [$bar] $cap%"
        test -n "$bstat"; and set line3 "$line3 · $bstat"
    end

    set -l text "welcome back, $user" "happy hacking" $line3
    set -l textrows (count $text)
    set -l total (math "2 * $band + $textrows")

    # --- build the rainbow palette once (each entry = truecolor escape + block) ---
    set -l palette
    for i in (seq 0 (math $palette_n - 1))
        set -l h (math "$i / $palette_n * 6")
        set -l seg (math "floor($h)")
        set -l x (math "1 - abs($h % 2 - 1)")
        set -l r 0
        set -l g 0
        set -l b 0
        switch $seg
            case 0
                set r 1; set g $x; set b 0
            case 1
                set r $x; set g 1; set b 0
            case 2
                set r 0; set g 1; set b $x
            case 3
                set r 0; set g $x; set b 1
            case 4
                set r $x; set g 0; set b 1
            case '*'
                set r 1; set g 0; set b $x
        end
        set -a palette (printf '\e[38;2;%d;%d;%dm█' \
            (math "round($r * 255)") (math "round($g * 255)") (math "round($b * 255)"))
    end

    # Tile the palette long enough that every frame/row can take a plain slice
    # (no modulo, no per-cell math in the animation loop).
    set -l need (math "$cols + $tilt * $total + $step * $frames + 2")
    set -l ext
    while test (count $ext) -lt $need
        set -a ext $palette
    end

    # Draw one full-width band row whose colors are offset by absolute row `ar`.
    function __fish_greeting_bandrow --inherit-variable ext --inherit-variable cols
        set -l ar $argv[1]
        set -l f $argv[2]
        set -l tilt $argv[3]
        set -l step $argv[4]
        set -l start (math "$tilt * $ar + $step * $f + 1")
        set -l stop (math "$start + $cols - 1")
        printf '%s\e[0m\n' (string join '' $ext[$start..$stop])
    end

    printf '\e[?25l' # hide cursor during the animation
    for f in (seq 0 (math $frames - 1))
        # top band: absolute rows 0 .. band-1
        for r in (seq 0 (math $band - 1))
            __fish_greeting_bandrow $r $f $tilt $step
        end
        # centered text, drawn between the bands
        for line in $text
            set -l pad (math "floor(($cols - "(string length -- $line)") / 2)")
            test $pad -lt 0; and set pad 0
            printf '\e[1;97m%s%s\e[0m\n' (string repeat -n $pad ' ') $line
        end
        # bottom band: absolute rows continue past the text rows
        for r in (seq 0 (math $band - 1))
            __fish_greeting_bandrow (math "$band + $textrows + $r") $f $tilt $step
        end
        if test $f -lt (math $frames - 1)
            sleep $delay
            printf '\e[%dA\r' $total # rewind to redraw the block in place
        end
    end
    printf '\e[?25h' # restore cursor
    functions -e __fish_greeting_bandrow
end
