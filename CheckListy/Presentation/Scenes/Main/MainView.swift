//
//  MainView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import SwiftUI

struct MainView: View {

    @StateObject private var listsViewModel = ListsViewModel()

    var body: some View {
        ListsView()
            .environmentObject(listsViewModel)
    }

}

#Preview {
    MainView()
}
