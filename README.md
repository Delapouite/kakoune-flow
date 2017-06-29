# kakoune-flow

[kakoune](http://kakoune.org) plugin to work with [flow](https://flow.org/), the JavaScript type checker.

## Install

Add `flow.kak` to your autoload dir: `~/.config/kak/autoload/`.

To use the `flow-coverage` command, you need to have [jq](https://stedolan.github.io/jq/) on your system.

## Usage

It provides the following commands:

- `flow-get-type`: display the type of the name under cursor in info (using `flow type-at-pos`)
- `flow-jump-to-definition`: jump to definition of the name under cursor (using `flow get-def`)
- `flow-coverage`: display the current file coverage in info and highlight missing coverage (using `flow coverage`)
- `flow-coverage-disable`: remove coverage highlighter
- `flow-select-references`: select references of the name under cursor (using `flow find-refs`)

## See also

- [vim-flow](https://github.com/flowtype/vim-flow)
- [eslint-formatter-kakoune](https://github.com/Delapouite/eslint-formatter-kakoune)

## Licence

MIT
