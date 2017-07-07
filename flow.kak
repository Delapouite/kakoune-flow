# get type

def flow-get-type -docstring 'display the type of the name under cursor in info' %{ %sh{
  type=$(flow type-at-pos "$kak_buffile" $kak_cursor_line $kak_cursor_column | head -n 1)
  anchor=$kak_cursor_line.$kak_cursor_column
  echo "info -title flow-get-type -anchor $anchor %^flow: $type^"
}}

decl -hidden bool flow_get_type_enabled false

def flow-get-type-toggle -hidden -docstring 'enable/disable auto flow-get-type on NormalIdle' %{ %sh{
  if [ $kak_opt_flow_get_type_enabled = true ]; then
    echo 'set window flow_get_type_enabled false'
    echo 'rmhooks window flow_get_type'
  else
    echo 'set window flow_get_type_enabled true'
    echo 'hook -group flow_get_type window NormalIdle .* flow-get-type'
  fi
}}

def flow-jump-to-definition -docstring 'jump to definition of the name under cursor' %{ %sh{
  location=$(flow get-def "$kak_buffile" $kak_cursor_line $kak_cursor_column | cut -d , -f 1 | tr ':' ' ')
  echo "edit $location"
}}

# coverage

decl -hidden range-specs flow_coverage

def flow-coverage -docstring 'display the current file coverage in info and highlight missing coverage' %{
  try %{ addhl ranges flow_coverage }
  %sh{
    percentage=$(flow coverage "$kak_buffile" | head -n 1)
    # --raw-output removes the surrounding dquotes
    coords=$(
      flow coverage "$kak_buffile" --json \
      | jq --raw-output '.expressions.uncovered_locs
          | map( [
              [ [ (.start.line|tostring), (.start.column|tostring)] | join(".") ],
              [ (.end.line|tostring), (.end.column|tostring)] | join(".")
            ]
            | join(",") )
          | join("|Error:")' \
    )
    echo "info -title flow-coverage '$percentage'"
    if [ -n "$coords" ]; then
      echo "set window flow_coverage '$kak_timestamp:$coords|Error';"
    else
      echo "flow-coverage-disable"
    fi
  }
}

def flow-coverage-disable -docstring 'remove coverage highlighter' %{ rmhl hlranges_flow_coverage }

# references

def flow-select-references -docstring 'select references of the name under cursor' %{ %sh{
  coords=$(flow find-refs "$kak_buffile" "$kak_cursor_line" "$kak_cursor_column" | cut -d : -f 2- | tr ':' '.' | tr '\n' ':' | sed 's/.$//'; echo '')
  if [ -n "$coords" ]; then
    echo "select $coords; echo $coords"
  else
    echo nop
  fi
}}
