declare-option str-list recent_buffers
declare-option str-list recent_buffers_freezed
declare-option str recent_buffers_head

define-command _debuggy_buggy -hidden %{
  info %sh{
    echo "$kak_quoted_opt_recent_buffers" | xargs -r printf "'%s'\n"
  }
}

hook global WinDisplay .* %{
  evaluate-commands  %sh{
    res=$(echo "$kak_quoted_opt_recent_buffers $kak_quoted_reg_percent" | xargs -r printf "'%s'\n" | grep "^'[^*]" | tac | awk '!seen[$0]++' | tac | xargs -r printf "'%s' ")
    echo "set-option global recent_buffers $res"
  }
}

hook global BufClose .* %{
  evaluate-commands  %sh{
    res=$(echo "$kak_quoted_opt_recent_buffers" | xargs -r printf "'%s'\n" | grep -v "$kak_bufname" | xargs -r printf "'%s' " )
    echo "set-option global recent_buffers $res"
    res=$(echo "$kak_quoted_opt_recent_buffers_freezed" | xargs -r printf "'%s'\n" | grep -v "$kak_bufname" | xargs -r printf "'%s' " )
    echo "set-option global recent_buffers_freezed $res"
  }
}

define-command recent-buffers-freeze %{
  set-option global recent_buffers_freezed %opt[recent_buffers]
  set-option global recent_buffers_head %reg[percent]
}

define-command recent-buffers-freezed-pick-link -override %{
  info -style modal  %sh{
  # res=$(paste -d' ' <(printf "j\nk\nl\n;") <(printf "$kak_quoted_opt_recent_buffers_freezed" | xargs -r printf "%s\n" | tac | tail -n +2 | head -4))
    res=$(printf "j\nk\nl\n;" | { printf "$kak_quoted_opt_recent_buffers_freezed" | xargs -r printf "%s\n" | tac | tail -n +1 | head -5 | { paste -d ' ' /dev/fd/3 /dev/fd/4; } 4>&0; } 3>&0)
    printf "$res"
  }
  on-key %{
    info -style modal
    buffer %sh{
      [ "$kak_key" = "j" ]           && printf $kak_opt_recent_buffers_head
      [ "$kak_key" = "k" ]           && printf "$kak_quoted_opt_recent_buffers_freezed" | xargs -r printf "%s\n" | tac | tail -n +2 | sed "1q;d"
      [ "$kak_key" = "l" ]           && printf "$kak_quoted_opt_recent_buffers_freezed" | xargs -r printf "%s\n" | tac | tail -n +2 | sed "2q;d"
      [ "$kak_key" = "<semicolon>" ] && printf "$kak_quoted_opt_recent_buffers_freezed" | xargs -r printf "%s\n" | tac | tail -n +2 | sed "3q;d"
    }
  }
}

define-command recent-buffers-pick-link -override %{
  info -style modal  %sh{
  # res=$(paste -d' ' <(printf "j\nk\nl\n;") <(printf "$kak_quoted_opt_recent_buffers" | xargs -r printf "%s\n" | tac | tail -n +2 | head -4))
    res=$(printf "j\nk\nl\n;" | { printf "$kak_quoted_opt_recent_buffers" | xargs -r printf "%s\n" | tac | tail -n +2 | head -4 | { paste -d ' ' /dev/fd/3 /dev/fd/4; } 4>&0; } 3>&0)
    printf "$res"
  }
  on-key %{
    info -style modal
    buffer %sh{
      [ "$kak_key" = "j" ]           && printf "$kak_quoted_opt_recent_buffers" | xargs -r printf "%s\n" | tac | tail -n +2 | sed "1q;d"
      [ "$kak_key" = "k" ]           && printf "$kak_quoted_opt_recent_buffers" | xargs -r printf "%s\n" | tac | tail -n +2 | sed "2q;d"
      [ "$kak_key" = "l" ]           && printf "$kak_quoted_opt_recent_buffers" | xargs -r printf "%s\n" | tac | tail -n +2 | sed "3q;d"
      [ "$kak_key" = "<semicolon>" ] && printf "$kak_quoted_opt_recent_buffers" | xargs -r printf "%s\n" | tac | tail -n +2 | sed "4q;d"
    }
  }
}

define-command recent-buffers-pull-chain -override %{
  buffer %sh{
    echo "$kak_quoted_opt_recent_buffers" | xargs -r printf "%s\n" | head -1
  }
}

define-command recent-buffers-loose-chain -override %{
  evaluate-commands %sh{
    last_=$(echo "$kak_quoted_opt_recent_buffers" | xargs -r printf "'%s'\n" | tail -1)
    init_=$(echo "$kak_quoted_opt_recent_buffers" | xargs -r printf "'%s'\n" | head -n -1 | xargs -r printf "'%s' ")
    echo "set-option global recent_buffers $last_ $init_"
    echo "$init_" | xargs -r printf "'%s'\n" | tail -1 | xargs -r printf "buffer \"%s\""
  }
}

define-command recent-buffers-freeze-buffer-impl -params 1 -override %{
  evaluate-commands %sh{
    printf "set-option -add global recent_buffers_freezed $1=$kak_reg_percent\n"
  }
}

define-command recent-buffers-freeze-buffer -override %{
  info -style modal  %sh{
    targets=$(
      echo $kak_quoted_opt_recent_buffers_freezed \
      | xargs printf "%s\n" \
      | grep "^j\|^k\|^l\|^<semicolon>" \
      | sort \
      | sed 's/<semicolon>/;/'
    )
    printf "$targets\n"
  }
  on-key %{
    info -style modal
    recent-buffers-freeze-buffer-impl %val{key}
  }
}

define-command recent-buffers-take-out-from-freezer -override %{
  info -style modal  %sh{
    targets=$(
      echo $kak_quoted_opt_recent_buffers_freezed \
      | xargs printf "%s\n" \
      | grep "^j\|^k\|^l\|^<semicolon>" \
      | sort \
      | sed 's/<semicolon>/;/'
    )
    printf "$targets\n"
  }
  on-key %{
    info -style modal
    evaluate-commands %sh{
      target=$(echo $kak_quoted_opt_recent_buffers_freezed | xargs printf "%s\n" | grep "^$kak_key")
      iwillfixitipromise=$(echo "$target" | sed -E 's/[^=]*=(.*)/\1/g')
      echo "edit -existing $iwillfixitipromise"
    }
  }
}
