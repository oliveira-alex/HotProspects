//
//  Prospect.swift
//  HotProspects
//
//  Created by Alex Oliveira on 13/11/2021.
//

import SwiftUI

enum ProspectsOrder {
    case name, mostRecent
}

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var addDate = Date()
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect] = []
    static let saveKey = "SavedData"
//    var peopleBackup: [Prospect] = [] // ContextMenu-Hack1

    init() {
        let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
        
        do {
            let data = try Data(contentsOf: filename)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func save() {
        let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
        
        do {
            let data = try JSONEncoder().encode(self.people)
            try data.write(to: filename, options: [.atomic])
        } catch {
            
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func remove(_ indexSet: IndexSet) {
        people.remove(atOffsets: indexSet)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
        
        // ContextMenu-Hack1. Without this, the list doesn't refresh after toggling isContacted
//        peopleBackup = people
//        people = []
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
//            self.people = self.peopleBackup
//        }
    }
    
    func sort(by order: ProspectsOrder) {
        switch order {
        case .name:
            people.sort { lhs, rhs in
                lhs.name < rhs.name
            }
        case .mostRecent:
            people.sort { lhs, rhs in
                lhs.addDate > rhs.addDate
            }
        }
        save()
    }
}
