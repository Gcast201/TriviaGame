//
//  TriviaQuestion.swift
//  TriviaGame
//
//  Created by Gaby Castellon on 10/14/24.
//

import Foundation

struct TriviaQuestion: Identifiable, Codable {
    var id = UUID()
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    var shuffledAnswers: [String] // This won't be decoded, we'll assign it manually.
    
    enum CodingKeys: String, CodingKey {
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }

    // Custom init to assign shuffledAnswers manually
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        question = try container.decode(String.self, forKey: .question)
        correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
        shuffledAnswers = (incorrectAnswers + [correctAnswer]).shuffled()
    }
    
    // Default init for manual creation of TriviaQuestion instances
    init(question: String, correctAnswer: String, incorrectAnswers: [String]) {
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
        self.shuffledAnswers = (incorrectAnswers + [correctAnswer]).shuffled()
    }
}

