# kakoune-flow

[kakoune](http://kakoune.org) plugin to work with [flow](https://flow.org/), the JavaScript type checker.

## Install

Add `flow.kak` to your autoload dir: `~/.config/kak/autoload/`.

## Usage

It provides the following commands:

- `flow-get-type`: display the type of the name under cursor in info (using `flow type-at-pos`)
- `flow-jump-to-definition`: jump to definition of the name under cursor (using `flow get-def`)

## See also

- [flow.vim](https://github.com/flowtype/vim-flow)

## Licence

MIT
