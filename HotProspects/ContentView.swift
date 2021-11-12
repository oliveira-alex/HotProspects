//
//  ContentView.swift
//  HotProspects
//
//  Created by Alex Oliveira on 11/11/2021.
//

import SwiftUI

class DelayedUpdater: ObservableObject {
    var value = 0 {
       willSet {
           objectWillChange.send()
       }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var updater = DelayedUpdater()
    
    var body: some View {
        Text("Value is: \(updater.value)")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
