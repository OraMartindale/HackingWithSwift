//
//  ContentView.swift
//  Project2Challenge
//
//  Created by Ora Martindale on 10/15/21.
//

import SwiftUI

struct ContentView: View {
    @State private var possibleMoves = ["Rock", "Paper", "Scissors"]
    @State private var currentMove = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var showSuccess = false

    var body: some View {
        VStack {
            Text("Your opponent has thrown")
            Text(possibleMoves[currentMove])
            Text("You should try to")
            Text(shouldWin ? "Win" : "Lose")
            HStack {
                ForEach(0 ..< possibleMoves.count) { number in
                    Button(action: { self.onClick(number) }) {
                        Text(possibleMoves[number])
                    }
                }
            }
        }
        .alert(isPresented: $showSuccess) {
            Alert(title: Text("Success"), message: Text("Success"), dismissButton: .default(Text("Continue")) {
                newGame()

            })
        }
    }

    func onClick(_ number: Int) {
        if shouldWin {
            if number > currentMove || (currentMove == possibleMoves.count - 1 && number == 0) {
                showSuccess = true
            }
        } else {
            if number < currentMove || (currentMove == 0 && number == possibleMoves.count - 1) {
                showSuccess = true
            }
        }

    }

    func newGame() {
        currentMove = Int.random(in: 0...2)
        shouldWin = Bool.random()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
