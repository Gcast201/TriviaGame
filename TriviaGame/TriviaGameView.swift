//
//  TriviaGameView.swift
//  TriviaGame
//
//  Created by Gaby Castellon on 10/14/24.
//
import SwiftUI

struct TriviaGameView: View {
    var numberOfQuestions: Int
    var timerDuration: Int
    var category: String  // Pass the selected category
    var questionType: String  // Pass the question type
    
    @State private var triviaQuestions: [TriviaQuestion] = []
    @State private var selectedAnswers: [Int: String] = [:]
    @State private var timeRemaining = 0
    @State private var isGameOver = false
    @State private var score = 0
    @State private var isLoading = true

    @Environment(\.presentationMode) var presentationMode  // Used for navigating back to the previous view
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading Questions...")
            } else if triviaQuestions.isEmpty {
                Text("No questions found. Try again.")
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(0..<triviaQuestions.count, id: \.self) { questionIndex in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(triviaQuestions[questionIndex].question)
                                    .font(.headline)
                                
                                ForEach(triviaQuestions[questionIndex].shuffledAnswers, id: \.self) { answer in
                                    AnswerButton(
                                        answer: answer,
                                        isSelected: selectedAnswers[questionIndex] == answer,
                                        action: {
                                            selectedAnswers[questionIndex] = answer
                                        }
                                    )
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }

                Text("Time remaining: \(timeRemaining)s")
                    .font(.headline)
                    .padding()
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            endGame()
                        }
                    }

                Button(action: {
                    endGame()
                }) {
                    Text("Submit")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(selectedAnswers.count != triviaQuestions.count) // Disable until all questions are answered
            }
        }
        .alert(isPresented: $isGameOver) {
            Alert(
                title: Text("Score"),
                message: Text("You scored \(score) out of \(numberOfQuestions)"),
                primaryButton: .default(Text("Play Again")) {
                    presentationMode.wrappedValue.dismiss() // Navigate back
                },
                secondaryButton: .cancel(Text("OK"))
            )
        }
        .onAppear {
            fetchTriviaQuestions()
        }
        .navigationTitle("Trivia Game")
        .navigationBarBackButtonHidden(true)
    }
    
    private func fetchTriviaQuestions() {
        // Fetch questions based on category and question type
        TriviaAPI.fetchTriviaQuestions(numberOfQuestions: numberOfQuestions, category: category, questionType: questionType) { questions in
            DispatchQueue.main.async {
                if let questions = questions {
                    triviaQuestions = questions
                    timeRemaining = timerDuration
                }
                isLoading = false
            }
        }
    }
    
    private func endGame() {
        calculateScore()
        isGameOver = true
    }
    
    private func calculateScore() {
        score = 0
        for (index, answer) in selectedAnswers {
            if triviaQuestions[index].correctAnswer == answer {
                score += 1
            }
        }
    }
}

struct AnswerButton: View {
    let answer: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(answer)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(isSelected ? Color.green.opacity(0.3) : Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
