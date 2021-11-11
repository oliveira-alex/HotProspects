//
//  ContentView.swift
//  HotProspects
//
//  Created by Alex Oliveira on 11/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab 1")
                .padding()
                .onTapGesture {
                    self.selectedTab = 1
                }
                .tabItem {
                    Image(systemName: "star")
                    Text("One")
                }
            
            Text("Tab 2")
                .padding()
                .onTapGesture {
                    self.selectedTab = 100 // Any integer makes switch tabs work, as long as it's not 1, because 1 was set for this tab with the tag modifier
                }
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Two")
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
