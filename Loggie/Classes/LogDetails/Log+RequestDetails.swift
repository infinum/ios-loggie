//
//  Log+RequestDetails.swift
//  Pods
//
//  Created by Filip Bec on 15/03/2017.
//
//

import UIKit

extension Log {

    var requestDataSource: [LogDetailsSection] {
        var sections: [LogDetailsSection] = []

        if let headers = request.allHTTPHeaderFields {
            let headersSection = LogDetailsSection(headerTitle: "Headers")
            sections.append(headersSection)

            headersSection.items = headers.map({ (key, value) -> LogDetailsItem in
                return LogDetailsItem.subtitle(key, value)
            })
        }

        if let url = request.url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            let queryParamsSection = LogDetailsSection(headerTitle: "Query params")
            sections.append(queryParamsSection)

            queryParamsSection.items = queryItems.map({ queryItem -> LogDetailsItem in
                return LogDetailsItem.subtitle(queryItem.name, queryItem.value)
            })
        }

        // TODO: refactor this - it will be used

        if let body = request.httpBody {
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
