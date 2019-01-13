//
//  UnmarshalingWithContextTests.swift
//  Marshal
//
//  Created by Bart Whiteley on 5/27/16.
//  Copyright © 2016 Utah iOS & Mac. All rights reserved.
//

import XCTest
import Marshal

class UnmarshalingWithContextTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testObjectMapping() {
        let obj = personsJSON()
        let context = DeserializationContext()
        let people: [Person] = try! obj.value(for: "people", inContext: context)
        let person: Person = try! obj.value(for: "person", inContext: context)
        XCTAssertEqual(people.first!.firstName, "Jason")
        XCTAssertEqual(person.firstName, "Jason")
        XCTAssertEqual(person.score, 42)
        XCTAssertEqual(people.last!.address!.city, "Cupertino")
    }
    
    func testObjectMappingErrors() {
        let obj = personsJSON()
        let context = DeserializationContext()
        
        let nPerson: AgedPerson? = try! obj.value(for: "person", inContext: context)
        XCTAssertNil(nPerson)
        
        let expectation = self.expectation(description: "error test")
        do {
            let _: AgedPerson = try obj.value(for: "person", inContext:context)
        }
        catch {
            if case MarshalError.keyNotFound = error {
                expectation.fulfill()
            }
        }
        
        let expectation2 = self.expectation(description: "error test for array")
        do {
            let _: [AgedPerson] = try obj.value(for: "persons", inContext: context)
        }
        catch {
            if case MarshalError.keyNotFound = error {
                expectation2.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    private func personsJSON() -> JSONObject {
        let path = Bundle(for: type(of: self)).path(forResource: "People", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        return try! JSONParser.JSONObjectWithData(data)
    }

}

private struct Address {
    var street: String!
    var city: String!
}

extension Address: UnmarshalUpdating {
    mutating func update(with object: MarshaledObject) throws {
        street = try object.value(for: "street")
        city = try object.value(for: "city")
    }
}

extension Address: UnmarshalingWithContext {
    static func value(from object: MarshaledObject, inContext context: DeserializationContext) throws -> Address {
        var address = context.newAddress()
        try address.update(with: object)
        return address
    }
}

private struct Person {
    var firstName: String!
    var lastName: String!
    var score: Int!
    var address: Address?
}

extension Person: UnmarshalUpdatingWithContext {
    mutating func update(object: MarshaledObject, inContext context: DeserializationContext) throws {
        firstName = try object.value(for: "first")
        lastName = try object.value(for: "last")
        score = try object.value(for: "score")
        address = try object.value(for: "address", inContext: context)
    }
}

extension Person: UnmarshalingWithContext {
    static func value(from object: MarshaledObject, inContext context: DeserializationContext) throws -> Person {
        var person = context.newPerson()
        try person.update(object: object, inContext: context)
        return person
    }
}

private struct AgedPerson {
    var age: Int = 0
}

extension AgedPerson: UnmarshalingWithContext {
    static func value(from object: MarshaledObject, inContext context: DeserializationContext) throws -> AgedPerson {
        var person = context.newAgedPerson()
        person.age = try object.value(for: "age")
        return person
    }
}

private class DeserializationContext {
    func newPerson() -> Person {
        return Person()
    }
    
    func newAddress() -> Address {
        return Address()
    }
    
    func newAgedPerson() -> AgedPerson {
        return AgedPerson()
    }
}
