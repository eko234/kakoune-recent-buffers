declare-option str-list recent_buffers

hook global WinDisplay .* %{
  evaluate-commands  %sh{
    # res=$(echo "$kak_quoted_opt_recent_buffers $kak_quoted_reg_percent" | xargs printf "'%s'\n" | grep "^'[^*]" | tac | awk '!seen[$0]++' | tac | xargs printf "'%s'\n" | xargs)
    res=$(echo "$kak_quoted_opt_recent_buffers $kak_quoted_reg_percent" | xargs printf "'%s'\n" | grep "^'[^*]" | tac | awk '!seen[$0]++' | tac | xargs printf "'%s' ")
    echo "set-option global recent_buffers $res"
  }
}

hook global BufClose .* %{
  evaluate-commands  %sh{
    # res=$(echo "$kak_quoted_opt_recent_buffers" | xargs printf "'%s'\n" | grep -v "$kak_bufname" | xargs printf "'%s' " | xargs)
    res=$(echo "$kak_quoted_opt_recent_buffers" | xargs printf "'%s'\n" | grep -v "$kak_bufname" | xargs printf "'%s' " )
    echo "set-option global recent_buffers $res"
  }
}

define-command show-recent-buffers -override %{
  info -style modal  %sh{
    res=$(paste -d' ' <(printf "j\nk\nl\n;") <(printf "$kak_quoted_opt_recent_buffers" | xargs printf "%s\n" | tac | tail -n +2 | head -4))
    printf "$res"
  }
  on-key %{
    info -style modal
    buffer %sh{
      [ "$kak_key" == "j" ]           && printf "$kak_quoted_opt_recent_buffers" | xargs printf "%s\n" | tac | tail -n +2 | sed "1q;d"
      [ "$kak_key" == "k" ]           && printf "$kak_quoted_opt_recent_buffers" | xargs printf "%s\n" | tac | tail -n +2 | sed "2q;d"
      [ "$kak_key" == "l" ]           && printf "$kak_quoted_opt_recent_buffers" | xargs printf "%s\n" | tac | tail -n +2 | sed "3q;d"
      [ "$kak_key" == "<semicolon>" ] && printf "$kak_quoted_opt_recent_buffers" | xargs printf "%s\n" | tac | tail -n +2 | sed "4q;d"
    }
  }
}

define-command pull-chain -override %{
  buffer %sh{
    echo "$kak_quoted_opt_recent_buffers" | xargs printf "%s\n" | head -1
  }
}

define-command loose-chain -override %{
  evaluate-commands %sh{
    last_=$(echo "$kak_quoted_opt_recent_buffers" | xargs printf "'%s'\n" | tail -1)
    init_=$(echo "$kak_quoted_opt_recent_buffers" | xargs printf "'%s'\n" | head -n -1 | xargs printf "'%s' ")
    echo "set-option global recent_buffers $last_ $init_"
    echo "$init_" | xargs printf "'%s'\n" | tail -1 | xargs printf "buffer \"%s\""
  }
}
