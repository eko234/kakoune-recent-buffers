# Kakoune Recent Buffers

## Motivation
Very often I'm working with 3 to 4 files that I want to cycle trough but using the
jumplist its often too complex, as it sometimes will take me back and forth when I just
want to go back, otoh, I love the idea of marks but I really use them for `anchoring` extremely
central files|buffers, these other `pivotal` buffers are not "important" enough to deserve a mark
at least to me, but I want to navigate around them withtou much fuzz, thus, I decided to make this
plugin which helps me move as I want and also lets me pick between the last 4 buffers I visited
very easily, I hope other people would find it useful.

## Use
when firing `recent-buffers-pick-link`, the keys `j`, `k`, `l` and `<semicolon>` will
respectively take you to the 2nd, 3rd, 4th and 5th lats visited buffer. `recent-buffers-loose-chain`
will go to the previous visited buffer and `recent-buffers-pull-chain` will get you to the first
buffer you visited, both commands keep the `ring like` shape of the buffer list, allowing you
to navigate between them seamlessly.

It will omit buffers with earbuds, works correctly with files that include spaces and
removes entries when buffers are closed.

## Suggested mappings
``` kakoune
plug "eko234/kakoune-recent-buffers" config %{
  declare-user-mode chain
  map global user l ": recent-buffers-pick-link<ret>" -docstring "recent buffers"
  map global user L ": enter-user-mode -lock chain<ret>" -docstring "chain mode"
  map global chain p ": recent-buffers-loose-chain<ret>" -docstring "loose"
  map global chain n ": recent-buffers-pull-chain<ret>" -docstring "pull"
}
```
