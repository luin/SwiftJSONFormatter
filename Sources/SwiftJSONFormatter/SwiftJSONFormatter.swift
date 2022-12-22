import Foundation

public struct SwiftJSONFormatter {
  private static func format(_ value: String, indent: String, newLine: String, separator: String, unescapeUnicodeSequence: Bool) -> String {
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
          let string = consumeString(chars, unescapeUnicodeSequence: unescapeUnicodeSequence)
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
  
  public static func beautify(_ value: String, indent: String = "  ", unescapeUnicodeSequence: Bool = false) -> String {
    format(value, indent: indent, newLine: "\n", separator: " ", unescapeUnicodeSequence: unescapeUnicodeSequence)
  }
  
  public static func minify(_ value: String, unescapeUnicodeSequence: Bool = false) -> String {
    format(value, indent: "", newLine: "", separator: "", unescapeUnicodeSequence: unescapeUnicodeSequence)
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
  
  private static func performUnescaping(_ jsonString: String, unescapeUnicodeSequence: Bool) -> String {
    if unescapeUnicodeSequence {
      let decoder = JSONDecoder()
      if let data = jsonString.data(using: .utf8), let result = try? decoder.decode(String.self, from: data) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        if let encoded = try? encoder.encode(result), let encodedString = String(data: encoded, encoding: .utf8) {
          return encodedString
        }
      }
    }

    return jsonString
  }
  
  private static func consumeString(_ iter: ArrayIterator<String.Element>, unescapeUnicodeSequence: Bool) -> String {
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
            return performUnescaping(string, unescapeUnicodeSequence: unescapeUnicodeSequence)
          }
        }
      } else {
        break
      }
    }
    
    return performUnescaping(string, unescapeUnicodeSequence: unescapeUnicodeSequence)
  }
}
