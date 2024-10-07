//
//  ContentView.swift
//  MatchedGeometryDemo
//
//  Created by Boyce Estes on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedDay = Date()
    @State private var recordsForDays = HabitRecord.preview(date: Date())
    var body: some View {
        HomeView(selectedDay: $selectedDay, recordsForDays: $recordsForDays)
    }
}

#Preview {
    ContentView()
}
