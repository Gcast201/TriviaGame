//
//  TriviaAPI.swift
//  TriviaGame
//
//  Created by Gaby Castellon on 10/14/24.
//

import Foundation

struct TriviaAPI {
    static func fetchTriviaQuestions(numberOfQuestions: Int, category: String, questionType: String, completion: @escaping ([TriviaQuestion]?) -> Void) {
        // Convert the questionType to API-supported values
        let apiQuestionType = questionType == "True or False" ? "boolean" : "multiple"
        
        // Get the category ID from the mapping
        let categoryID = getCategoryID(for: category)
        
        // Build the URL with the number of questions, category ID, and question type
        let urlString = "https://opentdb.com/api.php?amount=\(numberOfQuestions)&category=\(categoryID)&type=\(apiQuestionType)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        print("Fetching trivia from: \(urlString)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned from API.")
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TriviaResponse.self, from: data)
                
                print("Questions fetched: \(response.results.count)")
                
                // Shuffle answers for each question once and store them in shuffledAnswers
                let questions = response.results.map { question -> TriviaQuestion in
                    var modifiedQuestion = question
                    modifiedQuestion.shuffledAnswers = (question.incorrectAnswers + [question.correctAnswer]).shuffled()
                    return modifiedQuestion
                }
                
                completion(questions)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    // Step 1: Add the Category ID Mapping here
    private static func getCategoryID(for category: String) -> Int {
        let categoryIDMap: [String: Int] = [
            "General Knowledge": 9,
            "Sports": 21,
            "History": 23,
            "Science & Nature": 17,
            "Entertainment: Video Games": 15
        ]
        
        // Default to "General Knowledge" if the category isn't found
        return categoryIDMap[category] ?? 9
    }
}

struct TriviaResponse: Codable {
    var results: [TriviaQuestion]
}
