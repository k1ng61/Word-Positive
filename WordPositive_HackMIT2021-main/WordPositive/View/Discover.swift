//
//  Discover.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import SwiftUI

let COLORS: [Color] = [
  .red, .orange, .yellow,
  .green, .blue, .purple,
  .pink, .black
]

struct Discover: View {
  @State var currentGrade = 0
  
  var body: some View {
    let gradeWords = GradeWords.LEVELS[currentGrade]
    
    NavigationView {
      ZStack {
      ScrollView {
        VStack(alignment: .leading) {
          Text("Grade")
            .bold()
            .font(.title2)
          Divider()
          HStack {
            ForEach(0..<8) { num in
              Button(action: {
                currentGrade = num
              }) {
                Text("\(num + 1)")
                  .bold()
                  .foregroundColor(.white)
                  .frame(width: 30, height: 30)
                  .background(COLORS[num].opacity(num == currentGrade ? 1.0 : 0.3).cornerRadius(20))
              }
            }
          }
        }
        .padding()
        .background(Color(.systemGray5).cornerRadius(20).shadow(radius: 3))
        .padding()
        .padding(.bottom)
        
        VStack {
          ForEach(Array(zip(gradeWords.indices, gradeWords)), id: \.0) { index, word in
            WordBubble(word: word, index: index, gradeChoice: currentGrade)
          }
        }
      }
        LinearGradient(gradient: Gradient(colors: [.white, COLORS[currentGrade]]), startPoint: .topTrailing, endPoint: .bottomLeading).edgesIgnoringSafeArea(.all).opacity(0.5).zIndex(-1)
      }
      .navigationBarTitle("Discovery")
    }
  }
}

struct WordBubble: View {
  var word: String
  var index: Int
  var gradeChoice: Int
  @State var posFromTop: CGFloat = 0
  @State var selected = false
  
  var body: some View {
    let isRight = index % 2 == 0
    let scaleAmount = posFromTop != 0 ?
      1 - abs(posFromTop - (UIScreen.main.bounds.height / 2)) / (UIScreen.main.bounds.height / 2)
      : 1
    let color = COLORS[(gradeChoice + index) % GradeWords.LEVELS.count]
    
    HStack {
      if !isRight { Spacer() }
      Button(action: {
        selected = true
      }) {
        Text(word)
          .bold()
          .font(.title)
          .foregroundColor(.white)
          .frame(width: 200, height: 200)
          .background(
            color
              .cornerRadius(100)
          )
          .scaleEffect(scaleAmount * 0.5 + 0.5)
      }
      if isRight { Spacer() }
    }
    .sheet(isPresented: $selected) {
      AddDiscover(name: word, color: color)
    }
//    .onChange(of: posFromTop) { _ in
//      print(posFromTop)
//    }
    .background(rectReader($posFromTop))
  }
}

func rectReader(_ binding: Binding<CGFloat>) -> some View {
  return GeometryReader { (geometry) -> AnyView in
    let rect = geometry.frame(in: .global)
    DispatchQueue.main.async {
      binding.wrappedValue = rect.maxY
    }
    return AnyView(Rectangle().fill(Color.clear))
  }
}

struct Discover_Previews: PreviewProvider {
  static var previews: some View {
    Discover()
  }
}
