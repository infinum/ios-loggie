//
//  Log+ResponseDetails.swift
//  Pods
//
//  Created by Filip Bec on 15/03/2017.
//
//

import UIKit

extension Log {

    var responseDataSource: [LogDetailsSection] {
        var sections: [LogDetailsSection] = []

        if let headers = response?.allHeaderFields as? [String: String] {
            let headersSection = LogDetailsSection(headerTitle: "Headers")
            sections.append(headersSection)

            headersSection.items = headers.map({ (key, value) -> LogDetailsItem in
                return LogDetailsItem.subtitle(key, value)
            })
        }

        if let body = data {
            let bodySection = LogDetailsSection(headerTitle: "Body")
            sections.append(bodySection)

            if let jsonObject = try? JSONSerialization.jsonObject(with: body, options: [.allowFragments]),
                let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) {
                let jsonString = String(data: jsonData, encoding: .utf8)
                bodySection.items.append(.raw(jsonString))
            } else {
                let bodyString = String(data: body, encoding: .utf8)
                bodySection.items.append(.raw(bodyString))
            }
        }

        return sections
    }

}
