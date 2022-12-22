//
//  File.swift
//  
//
//  Created by Zihua Li on 2021/10/23.
//

import Foundation

class ArrayIterator<T> {
  private var array: [T] = []
  private(set) var head: Int = -1

  var hasNext: Bool {
    return head + 1 < array.count
  }

  init(_ array: [T]) {
    self.array = array
  }

  func peekNext(n: Int = 1) -> T? {
    if head + n < array.count {
      return array[head + n]
    }
    return nil
  }

  @discardableResult
  func next() -> T? {
    defer {
      head = head + 1
    }

    return peekNext()
  }
}
