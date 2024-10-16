//
//  ContentView.swift
//  TriviaGame
//
//  Created by Gaby Castellon on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var numberOfQuestions = 5
    @State private var selectedCategory = "General Knowledge"
    @State private var difficulty = "Easy"
    @State private var questionType = "Multiple Choice"
    @State private var timerDuration = 30
    
    let categories = ["General Knowledge", "Sports", "History", "Science & Nature", "Entertainment: Video Games"]
    let difficulties = ["Easy", "Medium", "Hard"]
    let questionTypes = ["Multiple Choice", "True or False"]
    let timerOptions = [30, 60, 120, 300, 3600]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Number of Questions")) {
                    Stepper(value: $numberOfQuestions, in: 1...20) {
                        Text("\(numberOfQuestions)")
                    }
                }
                
                Section(header: Text("Select Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Difficulty")) {
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(difficulties, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Select Type")) {
                    Picker("Question Type", selection: $questionType) {
                        ForEach(questionTypes, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Timer Duration")) {
                    Picker("Timer", selection: $timerDuration) {
                        ForEach(timerOptions, id: \.self) { option in
                            Text("\(option) seconds")
                        }
                    }
                }
                
                NavigationLink(destination: TriviaGameView(
                    numberOfQuestions: numberOfQuestions,
                    timerDuration: timerDuration,
                    category: selectedCategory,  // Pass the selected category
                    questionType: questionType  // Pass the selected question type
                )) {
                    Text("Start Trivia")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationBarTitle("Trivia Game")
        }
    }
}
