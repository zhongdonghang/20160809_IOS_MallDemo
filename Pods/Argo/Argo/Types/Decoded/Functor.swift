/**
  Conditionally map a function over a `Decoded` value.

  - If the value is `.Failure`, the function will not be evaluated and this
    will return `.Failure`.
  - If the value is `.Success`, the function will be applied to the unwrapped
    value.

  - parameter f: A transformation function from type `T` to type `U`
  - parameter x: A value of type `Decoded<T>`

  - returns: A value of type `Decoded<U>`
*/
public func <^> <T, U>(@noescape f: T -> U, x: Decoded<T>) -> Decoded<U> {
  return x.map(f)
}

public extension Decoded {
  /**
    Conditionally map a function over `self`.

    - If `self` is `.Failure`, the function will not be evaluated and this will
      return `.Failure`.
    - If `self` is `.Success`, the function will be applied to the unwrapped
      value.

    - parameter f: A transformation function from type `T` to type `U`

    - returns: A value of type `Decoded<U>`
  */
  func map<U>(@noescape f: T -> U) -> Decoded<U> {
    switch self {
    case let .Success(value): return .Success(f(value))
    case let .Failure(error): return .Failure(error)
    }
  }
}
