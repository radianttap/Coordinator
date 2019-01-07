//
//  TestObjects.swift
//  Marshal
//
//  Created by J. B. Whiteley on 4/23/16.
//  Copyright © 2016 Utah iOS & Mac. All rights reserved.
//

import Foundation
import Marshal

struct Recording: Unmarshaling {
    enum Status: String {
        case none = "0"
        case recorded = "-3"
        case recording = "-2"
        case unknown
    }
    
    enum RecGroup: String {
        case deleted = "Deleted"
        case defaultGroup = "Default"
        case liveTV = "LiveTV"
        case unknown
    }
    
    let startTsStr: String
    let status: Status
    let recordId: String
    let recGroup: RecGroup
    
    init(object json: MarshaledObject) throws {
        startTsStr = try json.value(for: "StartTs")
        recordId = try json.value(for: "RecordId")
        status = (try? json.value(for: "Status")) ?? .unknown
        recGroup = (try? json.value(for: "RecGroup")) ?? .unknown
    }
}

struct Program: Unmarshaling {
    
    let title: String
    let chanId: String
    let description: String?
    let subtitle: String?
    let recording: Recording
    let season: Int?
    let episode: Int?
    
    init(object json: MarshaledObject) throws {
        try self.init(jsonObj:json)
    }
    
    init(jsonObj: MarshaledObject, channelId: String? = nil) throws {
        let json = jsonObj
        title = try json.value(for: "Title")
        
        if let channelId = channelId {
            self.chanId = channelId
        }
        else {
            chanId = try json.value(for: "Channel.ChanId")
        }
        //startTime = try json.value(for: "StartTime")
        //endTime = try json.value(for: "EndTime")
        description = try json.value(for: "Description")
        subtitle = try json.value(for: "SubTitle")
        recording = try json.value(for: "Recording")
        season = (try json.value(for: "Season") as String?).flatMap({Int($0)})
        episode = (try json.value(for: "Episode") as String?).flatMap({Int($0)})
    }
}

extension Date: ValueType {
    public static func value(from object: Any) throws -> Date {
        guard let dateString = object as? String else {
            throw Marshal.MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
        guard let date = Date.fromISO8601String(dateString) else {
            throw Marshal.MarshalError.typeMismatch(expected: "ISO8601 date string", actual: dateString)
        }
        return date
    }
}

extension Date {
    static private let ISO8601MillisecondFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        let tz = TimeZone(abbreviation:"GMT")
        formatter.timeZone = tz
        return formatter
    }()
    static private let ISO8601SecondFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
        let tz = TimeZone(abbreviation:"GMT")
        formatter.timeZone = tz
        return formatter
    }()
    
    static private let formatters = [ISO8601MillisecondFormatter,
                                     ISO8601SecondFormatter]
    
    static func fromISO8601String(_ dateString: String) -> Date? {
        for formatter in formatters {
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return .none
    }
}

