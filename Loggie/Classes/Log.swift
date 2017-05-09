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

    func logDetailsItem(with data: Data, contentType: String?) -> LogDetailsItem? {
        var dataDecoder: DataDecoder?
        for decoder in Log.dataDecoders {
            if decoder.canDecode(data, contentType: contentType) {
                dataDecoder = decoder
                break
            }
        }
        guard let _dataDecoder = dataDecoder else {
            return nil
        }
        return _dataDecoder.decode(data, contentType: contentType)
    }

    func bodySection(with item: LogDetailsItem) -> LogDetailsSection {
        let section = LogDetailsSection(headerTitle: "Body")
        section.items.append(item)
        return section
    }

}

extension Log {

    public var stringReprezentation: String {
        var output: String = ""

        // MARK: - Overview -

        output += _formattedSectionTitle("OVERVIEW")

        if let method = request.httpMethod {
            output += _string(for: "METHOD", value: method)
        }
        if let responseStatus = response?.statusCode {
            output += _string(for: "RESPONSE STATUS", value: String(responseStatus))
        }
        if let startTime = startTime {
            let formatedDate = DateFormatter.localizedString(from: startTime, dateStyle: .medium, timeStyle: .medium)
            output += _string(for: "REQUEST TIME", value: formatedDate)
        }
        if let endTime = endTime {
            let formatedDate = DateFormatter.localizedString(from: endTime, dateStyle: .medium, timeStyle: .medium)
            output += _string(for: "RESPONSE TIME", value: formatedDate)
        }
        if let durationString = durationString {
            output += _string(for: "DURATION", value: durationString)
        }
        if let requestData = request.data {
            let sizeString = ByteCountFormatter.string(fromByteCount: Int64(requestData.count), countStyle: .memory)
            output += _string(for: "REQUEST SIZE", value: sizeString)
        }
        if let responseData = data {
            let sizeString = ByteCountFormatter.string(fromByteCount: Int64(responseData.count), countStyle: .memory)
            output += _string(for: "RESPONSE SIZE", value: sizeString)
        }

        // MARK: - REQUEST -

        output += _formattedSectionTitle("REQUEST")

        if let headers = request.allHTTPHeaderFields {
            let headersString: String = headers.map({ (key, value) -> String in
                return String(format: "%@: %@", key, value)
            }).joined(separator: "\n")
            output += _string(for: "HEADERS", value: headersString)
        }

        if let url = request.url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            let queryParamsString: String = queryItems.map({ queryItem -> String in
                return String(format: "%@: %@", queryItem.name, queryItem.value ?? "")
            }).joined(separator: "\n")
            output += _string(for: "QUERY PARAMS", value: queryParamsString)
        }

        if let body = request.data, let jsonString = body.formattedJsonString {
            output += _string(for: "BODY", value: jsonString)
        }

        // MARK: - RESPONSE -

        output += _formattedSectionTitle("RESPONSE")

        if let headers = response?.allHeaderFields as? [String: String] {
            let headersString: String = headers.map({ (key, value) -> String in
                return String(format: "%@: %@", key, value)
            }).joined(separator: "\n")
            output += _string(for: "HEADERS", value: headersString)
        }

        if let body = data, let jsonString = body.formattedJsonString {
            output += _string(for: "BODY", value: jsonString)
        }

        return output
    }

    private func _string(for title: String, value: String) -> String {
        return String(format: "\t%@:\n-----------------------\n%@\n\n", title, value)
    }

    private func _formattedSectionTitle(_ title: String) -> String {
        let line = "-----------"
        return [line, title, line].joined(separator: "\n") + "\n\n"
    }

}
