//
//  ContentView.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            ListItemsView()
                .environmentObject(ListItemViewModel())
        }
    }
    
}

#Preview {
    ContentView()
}
