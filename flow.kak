# get type

def flow-get-type -docstring 'display the type of the name under cursor in info' %{ %sh{
  type=$(flow type-at-pos "$kak_buffile" $kak_cursor_line $kak_cursor_column | head -n 1)
  anchor=$kak_cursor_line.$kak_cursor_column
  echo "info -title flow-get-type -anchor $anchor %^flow: $type^"
}}

decl -hidden bool flow_get_type_enabled false

def flow-get-type-toggle -hidden -docstring 'enable/disable flow-get-type on NormalIdle' %{ %sh{
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

decl -hidden str flow_coverage_percentage
decl -hidden range-specs flow_coverage

def -hidden flow-coverage-percentage -docstring 'display the current file coverage in percentage' %{
  info 'querying flow server…'
  # flow server takes more than 5secs to load
  %sh{
    {
      percentage=$(flow coverage "$kak_buffile" | head -n 1)
      cmd="set buffer flow_coverage_percentage '$percentage'; info -title flow-coverage '$percentage'"
      printf '%s\n' "eval -client $kak_client %< $cmd >" | kak -p "$kak_session"
    } < /dev/null > /dev/null 2>&1 &
  }
}

def flow-coverage -docstring 'display the current file coverage in info and highlight missing coverage' %{
  flow-coverage-percentage

  try %{ addhl ranges flow_coverage }
  %sh{
    {
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
      if [ -n "$coords" ]; then
        cmd="set window flow_coverage '$kak_timestamp:$coords|Error';"
      else
        cmd="flow-coverage-disable"
      fi
      printf '%s\n' "eval -client $kak_client %< $cmd >" | kak -p "$kak_session"
    } < /dev/null > /dev/null 2>&1 &
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
