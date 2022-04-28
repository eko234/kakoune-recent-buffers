# Kakoune Recent Buffers

I would show you suggeted mapping but in the end the functionality is kinda hardcoded,
when firing `show-recent-buffer`, the keys `j`, `k`, `l` and `<semicolon>` will
respectively take you to the 2nd, 3rd, 4th and 5th lats visited buffer.

It will omit buffers with earbuds, works correctly with files that include spaces and
removes entries when buffers are closed.

TODO:
  chain commands for movement get stuck, apparently when they get short of buffers it crashes,
  maybe some empty string si leaking somewere, but it works aside of that
