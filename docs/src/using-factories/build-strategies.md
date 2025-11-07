# build_stubbed and Marshal.dump

Note that objects created with `build_stubbed` cannot be serialized with
`Marshal.dump`, since factory\_bot defines singleton methods on these objects.
