declare-option str-list kakoune_recent_buffers

hook global WinDisplay .* %{
  set-option -add global kakoune_recent_buffers %reg{percent}
  set-option global kakoune_recent_buffers %sh{
    echo $kak_opt_kakoune_recent_buffers | tr ' ' '\n' | tac | awk '!seen[$0]++' | tac | tr '\n' ' '
  }
}

define-command show-recent-buffers -override %{
  info  %sh{
    res=$(paste -d' ' <(printf "j\nk\nl\n;") <(printf "$kak_opt_kakoune_recent_buffers" | tr ' ' '\n' | tac | tail -n +2))
    printf "$res"
  }
  on-key %{
    info
    buffer %sh{
      [ "$kak_key" == "j" ]           && printf "$kak_opt_kakoune_recent_buffers" | tr ' ' '\n' | tac | tail -n +2 | sed "1q;d"
      [ "$kak_key" == "k" ]           && printf "$kak_opt_kakoune_recent_buffers" | tr ' ' '\n' | tac | tail -n +2 | sed "2q;d"
      [ "$kak_key" == "l" ]           && printf "$kak_opt_kakoune_recent_buffers" | tr ' ' '\n' | tac | tail -n +2 | sed "3q;d"
      [ "$kak_key" == "<semicolon>" ] && printf "$kak_opt_kakoune_recent_buffers" | tr ' ' '\n' | tac | tail -n +2 | sed "4q;d"
    }
  }
}
