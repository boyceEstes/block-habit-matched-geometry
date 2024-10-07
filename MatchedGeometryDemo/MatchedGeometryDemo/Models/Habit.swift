//
//  Habit.swift
//  MatchedGeometryDemo
//
//  Created by Boyce Estes on 10/6/24.
//

import SwiftUI


struct Habit: Identifiable {
    
    let id = UUID()
    var name: String
    let color: Color
//    var records: [HabitRecord]
    
    
    init(name: String, color: Color) {
        self.name = name
        self.color = color
//        self.records = records
    }
}

extension Habit: Equatable {
    
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        lhs.name == rhs.name &&
        lhs.id == rhs.id
    }
}


extension Habit: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
