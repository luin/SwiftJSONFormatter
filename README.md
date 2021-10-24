# SwiftJSONFormatter

> 🪞 Formatter JSON delightfully.

[![CI](https://github.com/luin/SwiftJSONFormatter/actions/workflows/main.yml/badge.svg)](https://github.com/luin/SwiftJSONFormatter/actions/workflows/main.yml)

## Highlights

1. Beautify and minify JSON strings.
2. **Keep dictionary key order stable**.
3. Work with invalid JSON strings.
4. 100% pure Swift.
5. Lightweight and performant.

## Compatibility

* macOS 10.13+
* iOS 12+
* tvOS 12+
* watchOS 5+

## Install
Add `https://github.com/luin/SwiftJSONFormatter` in the [“Swift Package Manager” tab in Xcode](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).

## Usage

After `import SwiftJSONFormatter`, you can access two static methods for beautifying and minifying.

### Beautify

```swift
import SwiftJSONFormatter

SwiftJSONFormatter.beautify("{\"name\":\"Bob\"}")

// String output:
// {
//   "name": "Bob"
// }
```

By default, each level is indented by two spaces. You can customize it with the `indent` option:

```swift
import SwiftJSONFormatter

SwiftJSONFormatter.beautify("{\"name\":\"Bob\"}", indent: "    ")

// String output:
// {
//     "name": "Bob"
// }
```

### Minify

```swift
import SwiftJSONFormatter

SwiftJSONFormatter.minify("""
{
  "name": "Bob"
}
""")

// String output:
// {"name":"Bob"}
```

## FAQ

### Why another JSON formatter?

In some cases, you can leverage a JSON parser to parse your JSON string to a Swift data structure
and then encode it to a string with `JSONEncoder` and the `.prettyPrinted` option.

However, it comes with two drawbacks:

1. Dictionary key order are changed randomly everytime.

    Swift dictionary, by nature, are not designed to be ordered. That means everytime you encode your
    JSON data back to a string, the result may be much different from the original one.

    Whereas this libaray guarantees the dictionary key orders are not changed after formatting.

2. Doesn't work with invalid JSON data.

    This library makes a best effort to format invalid JSON data. It handles cases such as unterminated strings, trailing commas without issues.

These two drawbacks are non trivial when you are, for example, writing a JSON editor that accepts user inputs. You don't want dictionary key orders change
on each formatting, nor the formatter suddenly doesn't work at all when users enter a trailing commas.

### Can I use this as a JSON parser?

No. This library is not a JSON parser so here are what it cannot do:

1. Parse JSON strings into AST or Swift data structures.
2. Validate JSON strings.

You'll need to find a real one like [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) if those are what you need.
