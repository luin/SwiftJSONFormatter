import XCTest
@testable import SwiftJSONFormatter

final class SwiftJSONFormatterTests: XCTestCase {
  func testBeautify() throws {
    XCTAssertEqual(SwiftJSONFormatter.beautify("{}"), "{}")
    
    XCTAssertEqual(SwiftJSONFormatter.beautify("""
    {"name":"Bob","class":"first"}
    """), """
    {
      "name": "Bob",
      "class": "first"
    }
    """)
    
    XCTAssertEqual(SwiftJSONFormatter.beautify("""
          
    {"name":"Bob","class":"first",}
    """), """
    {
      "name": "Bob",
      "class": "first",
    }
    """)
    
    XCTAssertEqual(SwiftJSONFormatter.beautify("""
    {"name":"Bob","class":"first",     "friends": ["Jeff", "Lucy", "Hanmei"],  happy:
    true, license: null, age: 18
    
    }
    """), """
    {
      "name": "Bob",
      "class": "first",
      "friends": [
        "Jeff",
        "Lucy",
        "Hanmei"
      ],
      happy: true,
      license: null,
      age: 18
    }
    """)
    
    XCTAssertEqual(SwiftJSONFormatter.beautify("42"), "42")
    XCTAssertEqual(SwiftJSONFormatter.beautify("true"), "true")
    XCTAssertEqual(SwiftJSONFormatter.beautify(#""string""#), #""string""#)
    
    XCTAssertEqual(SwiftJSONFormatter.beautify(#"""
    [   "string"   ,  "contains\"",  "\\\"quotes\n"]
    """#), #"""
    [
      "string",
      "contains\"",
      "\\\"quotes\n"
    ]
    """#)
  }
  
  func testMinify() throws {
    XCTAssertEqual(SwiftJSONFormatter.minify("{}"), "{}")
    
    XCTAssertEqual(SwiftJSONFormatter.minify("""
    {
      "name": "Bob",
      "class": "first"
    }
    """), """
    {"name":"Bob","class":"first"}
    """)
    
    XCTAssertEqual(SwiftJSONFormatter.minify("""
          
    {"name":"Bob","class":"first",}
    """), """
    {"name":"Bob","class":"first",}
    """)
    
    XCTAssertEqual(SwiftJSONFormatter.minify("""
    {"name":"Bob","class":"first",     "friends": ["Jeff", "Lucy", "Hanmei"],    age: 18
    
    }
    """), """
    {"name":"Bob","class":"first","friends":["Jeff","Lucy","Hanmei"],age:18}
    """)
    
    XCTAssertEqual(SwiftJSONFormatter.minify("42"), "42")
    XCTAssertEqual(SwiftJSONFormatter.minify("true"), "true")
    XCTAssertEqual(SwiftJSONFormatter.minify(#""string""#), #""string""#)
    
    XCTAssertEqual(SwiftJSONFormatter.minify(#"""
    [   "string"   ,
    "contains\"",  "\\\"quotes\n"]
    """#), #"["string","contains\"","\\\"quotes\n"]"#)
  }
  
  func testUnicodeEscaping() {
    XCTAssertEqual(SwiftJSONFormatter.minify(
      #"["15\u00f8C"]"#,
      unescapeUnicodeSequence: false
    ),
      #"["15\u00f8C"]"#
    )
    XCTAssertEqual(SwiftJSONFormatter.minify(
      #"["15\u00f8C"]"#,
      unescapeUnicodeSequence: true
    ),
      #"["15øC"]"#
    )
    XCTAssertEqual(SwiftJSONFormatter.minify(
      #"["Bien pr\u00e9parer votre s\u00e9jour"]"#,
      unescapeUnicodeSequence: true
    ),
      #"["Bien préparer votre séjour"]"#
    )
    XCTAssertEqual(SwiftJSONFormatter.minify(
      #"["\u4F60\u597D\n \uD83D\uDE04\uD83D\uDE04\uD834\uDF06"]"#,
      unescapeUnicodeSequence: true
    ),
      #"["你好\n 😄😄𝌆"]"#
    )
    XCTAssertEqual(SwiftJSONFormatter.minify(
      #"["https://example.com"]"#,
      unescapeUnicodeSequence: true
    ),
      #"["https://example.com"]"#
    )
  }
}
