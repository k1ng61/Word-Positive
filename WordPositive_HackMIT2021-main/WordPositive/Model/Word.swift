//
//  Word.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import Foundation
import AVFoundation
import SwiftUI

struct Word: Codable, Hashable {
  var name: String
  var partOfSpeech: String
  var definition: String
  var examples: [String]?
  var synonyms: [String]?
  var level: Int
  var nextTime: Date? = Date()
  
  static var ExampleWords: [Word] = [
    Word(name: "Unexpected", partOfSpeech: "adjective", definition: "not expected or regarded as likely to happen", examples: ["his death was totally unexpected"], synonyms: ["unforeseen", "unanticipated"], level: 2),
    Word(name: "Flabbergasted", partOfSpeech: "adjective", definition: "greatly surprised or astonished", examples: ["this news has left me totally flabbergasted", "Johnny's new developments left Maria flabbergasted"], synonyms: ["astonished"], level: 3),
    Word(name: "Obsequious", partOfSpeech: "adjective", definition: "obedient or attentive to an excessive or servile degree", examples: ["they were served by obsequious waiters"], synonyms: ["servile", "ingratiating"], level: 1),
    Word(name: "Hackneyed", partOfSpeech: "adjective", definition: "lacking significance through having been overused", examples: ["hackneyed old sayings", "the significance of his article was diluted through overuse of hackneyed arguments"], synonyms: ["overused", "timeworn"], level: 4)
  ]
  
  static func getWords(text: String, onComplete: @escaping ([Word]?) -> Void) {
    let headers = [
      "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
      "x-rapidapi-key": "3d75d0493bmshdb8d80400bc1d81p10e6f1jsn9d4c76fa2ef7"
    ]
    guard let urlToQuery = NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/\(text)") else {
      return
    }
    let request = NSMutableURLRequest(url: urlToQuery as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      if (error != nil) {
        print(error as Any)
      } else {
        guard let data = data else { return }
        let responseObject = try? JSONDecoder().decode(WordData.self, from: data)
        let words = responseObject?.results.map({ responseData in
          return Word(
            name: text.capitalizingFirstLetter(),
            partOfSpeech: responseData.partOfSpeech,
            definition: responseData.definition,
            examples: responseData.examples,
            synonyms: responseData.synonyms,
            level: 0
          )
        })
        onComplete(words)
      }
    })

    dataTask.resume()
  }
  
  static func getDefFromContext(word: String, sentence: String, onComplete: @escaping (String?) -> Void) {
    let headers = ["word": word, "sentence": sentence]
    guard let urlToQuery = NSURL(string: "http://127.0.0.1:5000/definition") else { return }
    let request = NSMutableURLRequest(url: urlToQuery as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    print("Got through request configuration")
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        print(error as Any)
      }
      print("Got here, but might not have any data")
        
      guard let data = data else { return }
      print("Got data \(data)")
      let responseObject = try? JSONDecoder().decode(String.self, from: data)
      print("Got this from API call: \(responseObject)")
      onComplete(responseObject)
      
    })
    
    dataTask.resume()
  }
  
  static func speakWord(word: Word) {
    let utterance = AVSpeechUtterance(string: word.name)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    let synthesizer = AVSpeechSynthesizer()
    synthesizer.speak(utterance)
  }
}

struct WordData: Codable {
  var results: [WordDataResult]
}

struct WordDataResult: Codable {
  var definition: String
  var partOfSpeech: String
  var synonyms: [String]?
  var examples: [String]?
}

extension Word {
  static func getColorFromLevel(level: Int) -> Color {
    switch(level) {
    case 1: return .red
    case 2: return .orange
    case 3: return .yellow
    case 4: return Color.green.opacity(0.5)
    case 5: return .green
    default: return .black
    }
  }
}
