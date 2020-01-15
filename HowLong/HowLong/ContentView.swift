//
//  ContentView.swift
//  HowLong
//
//  Created by Gustaf Liljegren on 2019-12-23.
//  Copyright © 2019 Gustaf Liljegren. All rights reserved.
//
import Combine
import SwiftUI

class Gender: ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    
    static let types = ["Idontwanna", "Female", "Male", "Nonbinaru"]
    
    var type = 0 { didSet {update()} }
    
    func update() {
        didChange.send(())
    }
}

class Country: ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    
    static let types = ["Sweden", "USA", "China", "India", "Sierra Leone"]
    static let weights = [1, 0.9, 0.8, 0.7, 0,55]
    
    var type = 0 { didSet {update()} }
    
    func update() {
        didChange.send(())
    }
}

struct ContentView: View {
    @ObservedObject var gender = Gender()
    @ObservedObject var country = Country()

    @State private var birthdate = Date()
    @State private var doesExercise = false
    @State private var doesSmoke = false
    @State private var doesMcDonalds = false

    func getDaysLeft() -> Int {
        return Int(85*365*(doesExercise ? 1.2 : 1)*(doesSmoke ? 0.8 : 1)*(doesMcDonalds ? 0.9 : 1)) - Int(birthdate.distance(to: Date())/87000)
    }

    var body: some View {
        NavigationView {
            
            Form {
                Section{
                    Picker(selection: $gender.type, label: Text("Select your gender")) {
                        ForEach(0 ..< Gender.types.count) {
                            Text(Gender.types[$0]).tag($0)
                        }
                    }
                    Picker(selection: $country.type, label: Text("Select your country")) {
                        ForEach(0 ..< Country.types.count) {
                            Text(Country.types[$0]).tag($0)
                        }
                    }
                    DatePicker("Enter your birthdate", selection: $birthdate, displayedComponents: .date)
                }
                Section {
                    Toggle(isOn: $doesExercise) {
                        Text("Do you exercise regularly?")
                    }
                    Toggle(isOn: $doesSmoke) {
                        Text("Do you smoke?")
                    }
                    Toggle(isOn: $doesMcDonalds) {
                        Text("Do you do the McDonk?")
                    }
                }
                Text("You have \(getDaysLeft()) days left.").fontWeight(Font.Weight.bold)

            }
                .navigationBarTitle(Text("How Long?"))
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
