//
//  Prospect.swift
//  HotProspects
//
//  Created by Alex Oliveira on 13/11/2021.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    static let saveKey = "SavedData"
    var peopleBackup: [Prospect] = []

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        
        self.people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
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
}
