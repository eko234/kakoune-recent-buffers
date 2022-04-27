declare-option str-list recent_buffers

hook global WinDisplay .* %{
  # set-option -add global recent_buffers %reg{percent}
  evaluate-commands  %sh{
    res=$(echo "$kak_quoted_opt_recent_buffers" | xargs printf "'%s'\n" | grep "^'[^*]" | tac | awk '!seen[$0]++' | tac | xargs printf "'%s' ")
    echo "set-option global recent_buffers $kak_quoted_reg_percent $res"
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
