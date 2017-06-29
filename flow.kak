decl range-specs flow_coverage

def flow-get-type -docstring 'display the type of the name under cursor in info' %{ %sh{
  type=$(flow type-at-pos "$kak_buffile" $kak_cursor_line $kak_cursor_column | head -n 1)
  echo "info -title 'flow-get-type' '$type'"
}}

def flow-jump-to-definition -docstring 'jump to definition of the name under cursor' %{ %sh{
  location=$(flow get-def "$kak_buffile" $kak_cursor_line $kak_cursor_column | cut -d , -f 1 | tr ':' ' ')
  echo "edit $location"
}}

def flow-coverage -docstring 'display the current file coverage in info and highlight missing coverage' %{
  try %{ addhl ranges flow_coverage }
  %sh{
    percentage=$(flow coverage "$kak_buffile" | head -n 1)
    coords=$(
      flow coverage "$kak_buffile" --json \
      | jq '.expressions.uncovered_locs
          | map( [
              [ [ (.start.line|tostring), (.start.column|tostring)] | join(".") ],
              [ (.end.line|tostring), (.end.column|tostring)] | join(".")
            ]
            | join(",") )
          | join("|Error:")' \
      | tr -d '"'
    )
    echo "info -title 'flow-coverage' '$percentage';"
    if [ -n "$coords" ]; then
      echo "set window flow_coverage '$kak_timestamp:$coords|Error';"
    else
      echo "flow-coverage-disable"
    fi
  }
}

def flow-coverage-disable -docstring 'remove coverage highlighter' %{ rmhl hlranges_flow_coverage }
