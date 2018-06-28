A package that defines a common class, [`PackageResolver`][PackageResolver], for
defining how to resolve `package:` URIs. This class may be based on the current
isolate's package resolution strategy, but it may also be explicitly defined by
the user—for example, you could create a resolver that represents the strategy
used to compile a `.dart.js` file.

The Dart VM provides resolving `package:` URIs using a a **package spec**.

A package spec usually comes in the form of a `.packages` file on the
filesystem. It defines an individual root URL for each package name, so that
`package:$name/$path` resolves to `$root/$path`.
