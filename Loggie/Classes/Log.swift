//
//  LoggieRequest.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

public class Log: NSObject {

    static let dataDecoders: [DataDecoder] = [
        JSONDataDecoder(),
        PlainTextDataDecoder(),
        ImageDataDecoder()
    ]

    public var request: URLRequest
    public var response: HTTPURLResponse?
    public var data: Data?
    public var error: Error?

    public var startTime: Date?
    public var endTime: Date?

    public var duration: TimeInterval? {
        guard let start = startTime, let end = endTime else {
            return nil
        }
        return end.timeIntervalSince(start)
    }

    public var durationString: String? {
        guard let _duration = duration else {
            return nil
        }
        return String(format: "%dms", Int(_duration * 100.0))
    }

    public init(request: URLRequest) {
        self.request = request
    }

    internal func logDetailsItem(with data: Data, contentType: String?) -> LogDetailsItem? {
        var dataDecoder: DataDecoder?
        for decoder in Log.dataDecoders {
            if decoder.canDecode(data, contentType: contentType) {
                dataDecoder = decoder
            }
        }
        guard let _dataDecoder = dataDecoder else {
            return nil
        }
        return _dataDecoder.decode(data, contentType: contentType)
    }

    internal func bodySection(with item: LogDetailsItem) -> LogDetailsSection {
        let section = LogDetailsSection(headerTitle: "Body")
        section.items.append(item)
        return section
    }

}
