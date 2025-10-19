# zskribidi

Port of [skribidi](https://github.com/memononen/Skribidi) to Zig, building all dependencies with zig. The bindings are very new so please report any issues you find.

## Building
Requires Zig 0.15.1 or later.

```sh
zig build
```

## Running tests
```sh
zig build test
```

## Running example
```sh
zig build example
```

Displays some text in latin, non-latin and emojis which adapts the layout based on the window size.

## TODO
- [X] Create zigified bindings
- [ ] Port tests to zig (some done now)
- [ ] Port examples to zig (basic example done)

## License
Skribidi is MIT licensed, the code in this repository is also MIT licensed.