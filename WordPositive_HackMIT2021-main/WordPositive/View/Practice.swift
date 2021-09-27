//
//  Practice.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI

struct Practice: View {
  @AppStorage("words") var words: [Word] = []
  @State private var practiceWords: [Word]? = []
  
  var body: some View {
    let numText = practiceWords != nil ? practiceWords!.count : 0
    
    NavigationView {
      VStack(alignment: .leading) {
        VStack(alignment: .leading) {
          Text("Welcome.")
            .bold()
            .font(.title2)
            .foregroundColor(.blue)
          Text("You have \(Text("\(numText)").bold()) words to practice today.")
            .padding(.top, 2)
        }
        .padding(.top)
        
        Spacer()
        
        VStack(alignment: .leading) {
          Group {
            NavigationLink(destination: PracticeGame(items: practiceWords ?? [])) {
              Text("\(Image(systemName: "deskclock.fill"))  Practice Today's Words")
            }
            Divider()
            NavigationLink(destination: PracticeGame(items: words, everyWord :true)) {
              Text("\(Image(systemName: "arrowshape.zigzag.forward.fill")) Practice Every Word")
            }
          }
          .font(.headline)
          .padding(.vertical)
        }
        .padding()
        .background(Color(.systemGray5).cornerRadius(10).shadow(radius: 3))
        .padding(.horizontal, 15)
        
        Spacer()
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding()
      .navigationBarTitle("Practice")
    }
    // keeping words updated
    .onAppear {
      
      practiceWords = getNeededPractice()
    }
    .onChange(of: words) { pastWords in
      if words.count != pastWords.count {
        practiceWords = getNeededPractice()
      }
    }
  }
  
  func getNeededPractice() -> [Word] {
    var practiceArray: [Word] = []
    for word in words {
      if word.level == 0 {
        practiceArray.append(word)
      } else if (word.nextTime != nil) && (word.nextTime! < Date()) {
        practiceArray.append(word)
      }
    }
    return practiceArray
  }
  
}

struct Practice_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      Practice()
    }
  }
}
