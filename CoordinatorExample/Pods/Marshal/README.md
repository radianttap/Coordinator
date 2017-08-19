![](Logo/Logo.png)

![License](https://img.shields.io/dub/l/vibe-d.svg)
![Carthage](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)
![Platforms](https://img.shields.io/badge/Platform-iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20OS%20X-lightgrey.svg)
[![Build Status](https://travis-ci.org/utahiosmac/Marshal.svg?branch=master)](https://travis-ci.org/utahiosmac/Marshal)
[![codebeat badge](https://codebeat.co/badges/8a60765a-0a0f-47b4-8bca-d75adc462836)](https://codebeat.co/projects/github-com-utahiosmac-marshal)

# Marshal

In Swift, we all deal with JSON, plists, and various forms of `[String: Any]`. `Marshal` believes you don't need a Ph.D. in monads or magic mirrors to deal with these in an expressive and type safe way. `Marshal` will help you write declarative, performant, error handled code using the power of __Protocol Oriented Programming™__.

## Usage

Extracting values from `[String: Any]` using Marshal is as easy as

```swift
let name: String = try json.value(for: "name")
let url: URL = try json.value(for: "user.website") // extract from nested objects!
```

## Converting to Models

[Unmarshaling](https://en.wikipedia.org/wiki/Marshalling_(computer_science)) is the process of taking an intermediary data format (the _marshaled_ object) and tranforming it into a local representation. Think of marshaling as serialization and unmarshaling as deserialization, or coding and decoding, respectively.

Often we want to take a marshaled object (like `[String: Any]`) and unmarshal it into one of our local models—for example we may want to take some JSON and initialize one of our local models with it:

```swift
struct User: Unmarshaling {
    var id: Int
    var name: String
    var email: String

    init(object: MarshaledObject) throws {
        id = try object.value(for: "id")
        name = try object.value(for: "name")
        email = try object.value(for: "email")
    }
}
```

Now, just by virtue of supplying a simple initializer you can *pull your models directly out of `[String: Any]`*!

```swift
let users: [User] = try json.value(for: "users")
```

That was easy! Thanks, Protocol Oriented Programming™!

## Error Handling

Are you the shoot-from-the-hip type that doesn't care about errors? Use `try?` to give yourself an optional value. Otherwise, join us law-abiding folks and wrap your code in a `do-catch` to get all the juicy details when things go wrong.


## Add Your Own Values

Out of the box, `Marshal` supports extracting native Swift types like `String`, `Int`, etc., as well as `URL`, anything conforming to `Unmarshaling`, and arrays of  all the aforementioned types. It does not support extraction of more complex types such as `Date` due to the wide variety of date formats, etc.

However, Marshal doesn't just leave you up the creek without a paddle! Adding your own Marshal value type is as easy as extending your type with `ValueType`.

```swift
extension Date : ValueType {
    public static func value(from object: Any) throws -> Date {
        guard let dateString = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
        // assuming you have a Date.fromISO8601String implemented...
        guard let date = Date.fromISO8601String(dateString) else {
            throw MarshalError.typeMismatch(expected: "ISO8601 date string", actual: dateString)
        }
        return date
    }
}
```

By simply implementing `value(from:)`, Marshal allows you to immediately do this:

```swift
let birthDate: Date = json.value(for: "user.dob")
```

Protocol Oriented Programming™ strikes again!

## Back to the Marshaled Object

We've looked at going from our `[String: Any]` into our local models, but what about the other way around?

```swift
extension User: Marshaling {
    func marshaled() -> [String: Any] {
        return {
            "id": "id",
            "name" : name,
            "email": email
        }
    }
}
```

Now, you might be thinking "but couldn't I use reflection to do this for me automagically?" You could. And if you're into that, there are some other great frameworks for you to use. But Marshal believes mirrors can lead down the road to a world of hurt. Marshal lives in a world where What You See Is What You Get™, and you can easily adapt to APIs that snake case, camel case, or whatever case your backend developers are into. Marshal code is explicit and declarative. But don't just take Marshal's word for it—read the good word towards the end [here on the official Swift blog.](https://developer.apple.com/swift/blog/?id=37)

# Performance

Of course, Marshal wouldn't be the Marshal if it didn't have some of the fastest guns in the West. You should always take benchmarks with a grain of salt, but chew on [these benchmarks](https://github.com/bwhiteley/JSONShootout) for a bit anyway.


# Contributors

`Marshal` began as a [blog series on JSON parsing by Jason Larsen](http://jasonlarsen.me/2015/10/16/no-magic-json-pt3.html), but quickly evolved into a community project. A special thanks to the many people who have contributed at one point or another to varying degrees with ideas and code. A few of them, in alphabetical order:

* Bart Whiteley
* Brian Mullen
* Derrick Hathaway
* Dave DeLong
* Jason Larsen
* Mark Schultz
* Nate Bird
* Tim Shadel
