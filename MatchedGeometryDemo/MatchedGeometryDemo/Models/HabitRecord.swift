//
//  HabitRecord.swift
//  MatchedGeometryDemo
//
//  Created by Boyce Estes on 10/6/24.
//

import Foundation



// Habit 1:M HabitRecords
struct HabitRecord: Identifiable {
    
    let id = UUID()
    let timeCompletion: Date
    let habit: Habit
    
    
    init(timeCompletion: Date, habit: Habit) {
        
        self.timeCompletion = timeCompletion
        self.habit = habit
    }
}


extension HabitRecord: Equatable {
    
    static func == (lhs: HabitRecord, rhs: HabitRecord) -> Bool {
        lhs.timeCompletion == rhs.timeCompletion &&
        lhs.id == rhs.id &&
        lhs.habit == rhs.habit
    }
}

extension HabitRecord: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// Preview
#if DEBUG
extension HabitRecord {
    static func preview(date: Date) -> [Date: [HabitRecord]] {
        
        let today = date
        let oneDayAgo = date.adding(days: -1)
        let twoDaysAgo = date.adding(days: -2)
        let threeDaysAgo = date.adding(days: -3)
        let fourDaysAgo = date.adding(days: -4)
        let fiveDaysAgo = date.adding(days: -5)
        let sixDaysAgo = date.adding(days: -6)
        let sevenDaysAgo = date.adding(days: -7)
        let eightDaysAgo = date.adding(days: -8)
        
        let recordwalkTheCatToday = HabitRecord(timeCompletion: today, habit: .walkTheCat)
        let recordwalkTheCatOneDayAgo = HabitRecord(timeCompletion: oneDayAgo, habit: .walkTheCat)
        let recordwalkTheCatThreeDaysAgo = HabitRecord(timeCompletion: threeDaysAgo, habit: .walkTheCat)
        
        let recordMirrorPepTalkToday = HabitRecord(timeCompletion: today, habit: .mirrorPepTalk)
        let recordMirrorPepTalkTwoDaysAgo = HabitRecord(timeCompletion: twoDaysAgo, habit: .mirrorPepTalk)
        
        return [
            date: [recordwalkTheCatToday, recordMirrorPepTalkToday],
            oneDayAgo: [recordwalkTheCatOneDayAgo],
            twoDaysAgo: [recordMirrorPepTalkTwoDaysAgo],
            threeDaysAgo: [recordwalkTheCatThreeDaysAgo],
            fourDaysAgo: [],
            fiveDaysAgo: [],
            sixDaysAgo: [],
            sevenDaysAgo: [],
            eightDaysAgo: []
        ]
    }
}
#endif
