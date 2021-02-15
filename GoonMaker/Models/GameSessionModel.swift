//
//  GameSessionModel.swift
//  GoonMaker
//
//  Created by Gregory Keeley on 2/12/21.
//

import Foundation

struct GameSession: Codable {
    var isPlaying: Bool
    var lives: Int
    var userScore: UserScore
}

struct UserScore: Codable & Equatable {
    // Equatable
    static func == (lhs: UserScore, rhs: UserScore) -> Bool {
        return lhs.score > rhs.score
    }
    
    // User gets 3 lives, initialized in the GameViewController?
    // Do we want lives on the game session or view controller?
//    var livesRemaining: Int
    
    // NSUserDefaults should contain the name, if none is set,
    // we can prompt the user to go to settings, or provide dialog box?
    var userName: String
    
    // The actual users score to upload to firebase
    var score: Int

}
// Extension
extension UserScore {
     init(_ dictionary: [String: Any]) {
        
        self.userName = dictionary["userName"] as? String ?? "No User Name"
        self.score = dictionary["score"] as? Int ?? -1
//        self.livesRemaining = dictionary["livesRemaining"] as? Int ?? -1
    }
}
