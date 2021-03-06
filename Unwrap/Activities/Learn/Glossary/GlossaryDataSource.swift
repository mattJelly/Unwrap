//
//  GlossaryDataSource.swift
//  Unwrap
//
//  Created by Paul Hudson on 09/01/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class GlossaryDataSource: NSObject, UITableViewDataSource {
    var sortedEntries = [String: [GlossaryEntry]]()
    var sectionTitles = [String]()

    override init() {
        let entries = Bundle.main.decode([GlossaryEntry].self, from: "glossary.json")
        sortedEntries = Dictionary(grouping: entries) { String($0.term.prefix(1)).uppercased() }
        sectionTitles = [String](sortedEntries.keys).sorted()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        return sortedEntries[sectionTitle]?.count ?? 0
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let key = sectionTitles[indexPath.section]
        if let entries = sortedEntries[key] {
            let entry = entries[indexPath.row]
            cell.textLabel?.text = entry.term
            cell.detailTextLabel?.attributedText = entry.description.fromSimpleHTML()
        }

        return cell
    }
}
