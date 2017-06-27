def flow-get-type -docstring 'display the type of the name under cursor in info' %{ %sh{
  type=$(flow type-at-pos $kak_buffile $kak_cursor_line $kak_cursor_column | head -n 1)
  echo "info -title 'flow-get-type' '$type'"
}}

def flow-jump-to-definition -docstring 'jump to definition of the name under cursor' %{ %sh{
  location=$(flow get-def $kak_buffile $kak_cursor_line $kak_cursor_column | cut -d , -f 1 | tr ':' ' ')
  echo "edit $location"
}}
