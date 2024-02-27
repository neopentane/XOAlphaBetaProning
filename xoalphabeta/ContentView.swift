//
//  ContentView.swift
//  xoalphabeta
//
//  Created by Shreeram Kelkar on 27/02/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var grid : [[Int]] = [[0,0,0],[0,0,0],[0,0,0]]
    @State var turn = 0
    @State var gameState : GameState = .playing
    var body: some View {
        VStack {
            switch gameState {
            case .xwin:
                Text("X Won")
            case .owin:
                Text("O Won")
            case .draw:
                Text("Draw")
            case .playing:
                if turn % 2 == 0 {
                    Text("X Turn")
                } else {
                    Text("O Turn")
                }
            }
            ForEach(0...grid.count - 1, id: \.self) { row in
                HStack {
                    ForEach(0...grid[0].count - 1, id: \.self) { col in
                        VStack {
                            Button {
                                if gameState == .playing {
                                    playAt(row: row, col: col)
                                }
                            } label: {
                                if grid[row][col] == 0 {
                                    Text("_")
                                        .frame(minWidth: 75,minHeight: 75)
                                } else if grid[row][col] == 1 {
                                    Text("X")
                                        .frame(minWidth: 75,minHeight: 75)
                                } else if grid[row][col] == 2 {
                                    Text("O")
                                        .frame(minWidth: 75,minHeight: 75)
                                }
                            }
                            
                        }
                    }
                }
            }
            HStack {
                Button {
                    startGame()
                } label: {
                    Text("New Game")
                }
            }
        }
        
    }
    
    func alphaBeta(turn t: Int,game: [[Int]]) -> ([[Int]],GameState){
        let gameState =  checkWin(game, t)
        switch gameState {
        case .xwin:
            return (game,.xwin)
        case .owin:
            return (game,.owin)
        case .draw:
            return (game,.draw)
        case .playing:
            var drawingState : [[Int]] = [[]]
            var losingState: [[Int]] = [[]]
            for i in 0...game.count-1 {
                for j in 0...game.count-1 {
                    if game[i][j] == 0 {
                        if t % 2 == 0 {
                            var newgame = game
                            newgame[i][j] = 1
                            let newturn = t+1
                            let (_,state) = alphaBeta(turn: newturn, game: newgame)
                            if state == .xwin {
                                return (newgame,state)
                            } else if state == .draw {
                                drawingState = newgame
                            } else if state == .owin {
                                losingState = newgame
                            }
                        } else {
                            var newgame = game
                            newgame[i][j] = 2
                            let newturn = t+1
                            let (_,state) = alphaBeta(turn: newturn, game: newgame)
                            if state == .owin {
                                return (newgame,state)
                            } else if state == .draw {
                                drawingState = newgame
                            } else if state == .xwin {
                                losingState = newgame
                            }
                        }
                    }
                }
            }
            if drawingState != [[]] {
                return (drawingState,.draw)
            } else {
                return (losingState,t % 2 == 0 ? .owin : .xwin)
            }
        }
    }
    
    func startGame() {
        self.turn = 0
        self.gameState = .playing
        self.grid = [[0,0,0],[0,0,0],[0,0,0]]
    }
    
    func playAt(row r: Int,col c: Int) {
        if grid[r][c] == 0 {
            if turn % 2 == 0 {
                grid[r][c] = 1
            }
            else {
                grid[r][c] = 2
            }
            turn += 1
            self.gameState = checkWin(grid,turn)
            let (game,_) = alphaBeta(turn: turn, game: grid)
            self.grid = game
            turn += 1
            self.gameState = checkWin(grid, turn)
        }
    }
    
    func checkWin(_ grid: [[Int]],_ turn : Int) -> GameState{
        // check col
        for i in 0...grid.count - 1 {
            var xs = 0
            var os = 0
            for j in 0...grid[0].count - 1 {
                if grid[i][j] == 1 {
                    xs += 1
                } else if grid[i][j] == 2 {
                    os += 1
                }
            }
            if xs == 3 {
                return .xwin
            }
            if os == 3 {
                return .owin
            }
        }
        // check row
        
        for i in 0...grid.count - 1 {
            var xs = 0
            var os = 0
            for j in 0...grid[0].count - 1 {
                if grid[j][i] == 1 {
                    xs += 1
                } else if grid[j][i] == 2 {
                    os += 1
                }
            }
            if xs == 3 {
                return .xwin
            }
            if os == 3 {
                return .owin
            }
        }

        // check diagoal
        var digx = 0
        var digy = 0
        for i in 0...grid.count - 1 {
            
            if grid[i][i] == 1 {
                digx += 1
            } else if grid[i][i] == 2 {
                digy += 1
            }
        }
        if digx == 3 {
            return .xwin
        }
        if digy == 3 {
            return .owin
        }
        digx = 0
        digy = 0
        let max = grid.count - 1
        for i in 0...grid.count - 1 {
            if grid[i][max-i] == 1 {
                digx += 1
            } else if grid[i][max-i] == 2 {
                digy += 1
            }
        }
        if digx == 3 {
            return .xwin
        }
        if digy == 3 {
            return .owin
        }
        
        if turn == 9 {
            return .draw
        }

        return .playing
    }
}

enum GameState {
    case xwin
    case owin
    case draw
    case playing
}

#Preview {
    ContentView()
}
