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
            let contentType = response?.allHeaderFields["Content-Type"] as? String
            let item = logDetailsItem(with: body, contentType: contentType)
            if let item = item {
                sections.append(bodySection(with: item))
            }
        }

        return sections
    }

}
