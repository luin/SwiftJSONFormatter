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
}
