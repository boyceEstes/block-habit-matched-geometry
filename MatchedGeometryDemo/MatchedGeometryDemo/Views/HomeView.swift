//
//  HomeView.swift
//  MatchedGeometryDemo
//
//  Created by Boyce Estes on 10/6/24.
//

import SwiftUI





extension Date {
    
    func adding(days: Int) -> Date {
        
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}


extension Habit {
    
    static var walkTheCat = Habit(
        name: "Walk The Cat",
        color: Color.red
    )
    
    static var drinkTheKoolaid = Habit(
        name: "Drink the Koolaid",
        color: Color.orange
    )
    static var mopTheCarpet = Habit(
        name: "Mop the carpet",
        color: Color.cyan
    )
    static var soulSearch =  Habit(
        name: "Soul Search",
        color: Color.pink
    )
    static var mirrorPepTalk = Habit(
        name: "Mirror Pep Talk",
        color: Color.indigo
    )
    static var somethingComplicated = Habit(
        name: "Stretching into a triple backflip IMMEDIATELY after waking up",
        color: Color.green
    )
    static var channelSurf = Habit(
        name: "Channel Surf",
        color: .red
    )
    
    
    static var availableHabits: [Habit] = [.walkTheCat, .drinkTheKoolaid, .mopTheCarpet, .soulSearch, .mirrorPepTalk, .somethingComplicated, .channelSurf]
}



struct HomeView: View {
    
    // MARK: Constants
    let numOfItemsToFillBarView = 16.0
    // MARK: View Properties
    @Namespace private var animation
    let availableHabits = Habit.availableHabits
    // MARK: Injected Properties
    @Binding var selectedDay: Date
    @Binding var recordsForDays: [Date: [HabitRecord]]
    
    

    
    var body: some View {
        
        GeometryReader { proxy in
            
            VStack {
                
                BarView(
                    selectedDay: $selectedDay,
                    recordsForDays: recordsForDays,
                    graphWidth: proxy.size.width,
                    graphHeight: proxy.size.height / 2,
                    numOfItemsToReachTop: numOfItemsToFillBarView,
                    animation: animation
                )

                HabitMenu
            }
        }
    }
    
    
    var HabitMenu: some View {
        VStack {
            Text("Habit Menu")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                
                ForEach(availableHabits) { habit in
                    Button {
                        tappedHabitButton(habit)
                    } label: {
                        Text("\(habit.name)")
                            .lineLimit(2, reservesSpace: true)
                            .frame(maxWidth: .infinity)
                    }
                    
                    .buttonStyle(.borderedProminent)
                    .tint(habit.color)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
    
    
    private func tappedHabitButton(_ habit: Habit) {
        
        let habitRecord = HabitRecord(timeCompletion: Date(), habit: habit)
        
        if recordsForDays[selectedDay] == nil {
            recordsForDays[selectedDay] = [habitRecord]
        } else {
            recordsForDays[selectedDay]!.append(habitRecord)
        }
    }
}


extension DateFormatter {
    
    static var shortDate: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}


struct BarView: View {
    
    // MARK: Injected Properties
    @Binding var selectedDay: Date
    let recordsForDays: [Date: [HabitRecord]]
    
    let graphWidth: CGFloat
    let graphHeight: CGFloat
    let numOfItemsToReachTop: Double
    let animation: Namespace.ID
    
    
    var body: some View {
        
        // TODO: If the device is horizontal, do not use this calculation
        let columnWidth = graphWidth / 5
        
        VStack {
            
            ScrollViewReader { value in
                
                ScrollView(.horizontal) {
                    
                    LazyHStack(spacing: 0) {
                        
                        ForEach(recordsForDays.sorted(by: { $0.key < $1.key}), id: \.key) { date, records in
                            
                            dateColumn(
                                graphHeight: graphHeight,
                                numOfItemsToReachTop: numOfItemsToReachTop,
                                date: date,
                                records: records
                            )
                            .frame(width: columnWidth, height: graphHeight, alignment: .bottom)
                            .id(date)
                        }
                    }
                    .frame(height: graphHeight)
                }
                .onChange(of: recordsForDays, { oldValue, newValue in
                    
                    scrollToSelectedDay(value: value, animate: false)
                })
                .onChange(of: selectedDay) { oldValue, newValue in
                    scrollToSelectedDay(value: value)
                }
                .onAppear {
                    scrollToSelectedDay(value: value, animate: false)
                }
            }
        }
    }
    
    
    @ViewBuilder
    func dateColumn(
        graphHeight: Double,
        numOfItemsToReachTop: Double,
        date: Date,
        records: [HabitRecord]
    ) -> some View {
        
        let habitCount = records.count
        let labelHeight: CGFloat = 30
        // This will also be the usual height
        let itemWidth = (graphHeight - labelHeight) / numOfItemsToReachTop
        let itemHeight = habitCount > Int(numOfItemsToReachTop) ? ((graphHeight - labelHeight) / Double(habitCount)) : itemWidth
        
        VStack(spacing: 0) {
            
            HabitRecordBlocksOnDate(
                records: records,
                itemWidth: itemWidth,
                itemHeight: itemHeight,
                animation: animation
            ) {
                // MARK: TO CHANGE OR NOT TO CHANGE
                print("tapped on a column")
                setSelectedDay(to: date)
            }
            
            Rectangle()
                .fill(.ultraThickMaterial)
                .frame(height: 1)
            
            Text("\(DateFormatter.shortDate.string(from: date))")
                .font(.footnote)
                .fontWeight(date == selectedDay ? .bold : .regular)
                .frame(maxWidth: .infinity, maxHeight: labelHeight)
                .onTapGesture {
                    // MARK: TO CHANGE OR NOT TO CHANGE
                    print("tapped on display date")
                    setSelectedDay(to: date)
                }
        }
    }
    
    
    private func setSelectedDay(to date: Date) {
        
        selectedDay = date
    }
    
    
    private func scrollToSelectedDay(value: ScrollViewProxy, animate: Bool = true) {
        
        DispatchQueue.main.async {
            // get days since january and then count back to get their ids, or I could
            // set the id as a date
            if animate {
                withAnimation(.easeInOut) {
                    value.scrollTo(selectedDay, anchor: .center)
                }
            } else {
                value.scrollTo(selectedDay, anchor: .center)
            }
        }
    }
}


struct HabitRecordBlocksOnDate: View {
    
    let records: [HabitRecord]
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let animation: Namespace.ID
    let didTapBlock: () -> Void
    
    var body: some View {
        
        ForEach(records) { habitRecord in
            
//            let isLastRecord = records.first == habitRecord
            
            ActivityBlock(
                id: habitRecord.id.uuidString,
                color: habitRecord.habit.color,
                itemWidth: itemWidth,
                itemHeight: itemHeight,
                animation: animation,
                tapAction: didTapBlock
            )
//            .clipShape(
//                UnevenRoundedRectangle(
//                    cornerRadii: .init(
//                        topLeading: isLastRecord ? .bigBlockCornerRadius : 0,
//                        topTrailing: isLastRecord ? .bigBlockCornerRadius : 0
//                    )
//                )
//            )
        }
    }
}


struct ActivityBlock: View {
    
    let id: String
    let color: Color
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let animation: Namespace.ID
    let tapAction: () -> Void
    
    init(
        id: String,
        color: Color,
        itemWidth: CGFloat,
        itemHeight: CGFloat,
        animation: Namespace.ID,
        tapAction: @escaping () -> Void = {}
    ) {
        self.id = id
        self.color = color
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.animation = animation
        self.tapAction = tapAction
    }
    
    
    var body: some View {
        
        Rectangle()
            .fill(color)
            .frame(width: itemWidth, height: itemHeight)
            .matchedGeometryEffect(id: id, in: animation)
            .onTapGesture(perform: tapAction)
    }
}


#Preview {
    @State var selectedDay = Date()
    @State var recordsForDays = HabitRecord.preview(date: Date())
    return HomeView(selectedDay: $selectedDay, recordsForDays: $recordsForDays)
}
