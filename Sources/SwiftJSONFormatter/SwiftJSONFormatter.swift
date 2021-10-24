public struct SwiftJSONFormatter {
  public private(set) var text = "Hello, World!"
  
  private static func format(_ value: String, indent: String, newLine: String, separator: String) -> String {
    var formatted = ""
    
    let chars = ArrayIterator(Array(value))
    var indentLevel = 0
    while true {
      if let char = chars.next() {
        switch char {
        case "{", "[":
          formatted.append(char)
          
          consumeWhitespaces(chars)
          let peeked = chars.peekNext()
          if peeked == "}" || peeked == "]" {
            chars.next()
            formatted.append(peeked == "}" ? "}" : "]")
          } else {
            indentLevel += 1
            formatted.append(newLine)
            formatted.append("\(String(repeating: indent, count: indentLevel))")
          }
        case "}", "]":
          indentLevel -= 1
          formatted.append(newLine)
          formatted += "\(String(repeating: indent, count: indentLevel))\(char)"
        case "\"":
          let string = consumeString(chars)
          formatted.append(string)
        case ",":
          consumeWhitespaces(chars)
          formatted.append(",")
          let peeked = chars.peekNext()
          if peeked != "}" && peeked != "]" {
            formatted.append(newLine)
            formatted.append("\(String(repeating: indent, count: indentLevel))")
          } // else: trailing ","
        case ":":
          formatted.append(":\(separator)")
        default:
          if !char.isWhitespace {
            formatted += "\(char)"
          }
        }
      } else {
        break
      }
    }
    
    return formatted
  }
  
  public static func beautify(_ value: String, indent: String = "  ") -> String {
    format(value, indent: indent, newLine: "\n", separator: " ")
  }
  
  public static func minify(_ value: String) -> String {
    format(value, indent: "", newLine: "", separator: "")
  }
  
  private static func consumeWhitespaces(_ iter: ArrayIterator<String.Element>) {
    while iter.hasNext {
      if iter.peekNext()?.isWhitespace ?? false {
        iter.next()
      } else {
        break
      }
    }
  }
  
  private static func consumeString(_ iter: ArrayIterator<String.Element>) -> String {
    var string = "\""
    var escaping = false
    while true {
      if let char = iter.next() {
        if char.isNewline {
          return string // Unterminated string
        }
        
        string.append(char)
        
        if escaping {
          escaping = false
        } else {
          if char == "\\" {
            escaping = true
          }
          if char == "\"" {
            return string
          }
        }
      } else {
        break
      }
    }
    return string
  }
}
