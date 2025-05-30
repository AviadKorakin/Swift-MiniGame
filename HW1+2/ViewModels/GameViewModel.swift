import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var round = 0
    @Published var scoreEast = 0
    @Published var scoreWest = 0
    @Published var currentPair: (east: String, west: String)? = nil
    @Published var isRevealed = false
    @Published var gameOver = false
    @Published var winner: String? = nil

    public let totalRounds = 10
    let eastBackImageName = "east_card_back"
    let westBackImageName = "west_card_back"

    private let eastDeck: [String]
    private let westDeck: [String]
    private let strengths: [String: Int]

    // Scheduler
    private var nextWorkItem: DispatchWorkItem?
    private var scheduledDate: Date?
    private var timeRemaining: TimeInterval?

    init(playerSide: String) {
        self.eastDeck = (1...13).map { "east_card\($0)" }
        self.westDeck = (1...13).map { "west_card\($0)" }
        var map = [String: Int]()
        for (i, name) in eastDeck.enumerated() { map[name] = i + 1 }
        for (i, name) in westDeck.enumerated() { map[name] = i + 1 }
        strengths = map
    }

    func start() {
        // Reset state
        round = 0
        scoreEast = 0
        scoreWest = 0
        gameOver = false
        winner = nil
        currentPair = nil
        isRevealed = false

        // Clear any old schedule
        nextWorkItem?.cancel()
        scheduledDate = nil
        timeRemaining = nil

        // Schedule first round after 5s
        scheduleNext(after: 5)
    }

    private func scheduleNext(after delay: TimeInterval) {
        // Cancel any existing
        nextWorkItem?.cancel()

        // Record when it should fire
        scheduledDate = Date().addingTimeInterval(delay)
        timeRemaining = nil

        let work = DispatchWorkItem { [weak self] in
            self?.nextRound()
        }
        nextWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }

    private func nextRound() {
        guard round < totalRounds else {
            endGame()
            return
        }

        // Draw & reveal
        let e = eastDeck.randomElement()!, w = westDeck.randomElement()!
        currentPair = (east: e, west: w)
        isRevealed = true

        // Update scores
        let sE = strengths[e]!, sW = strengths[w]!
        if sE != sW {
            if sE > sW { scoreEast += 1 } else { scoreWest += 1 }
        }
        round += 1

        // Hide after 3s
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isRevealed = false
        }

        // Schedule next flip
        scheduleNext(after: 5)
    }

    private func endGame() {
        nextWorkItem?.cancel()
        scheduledDate = nil
        winner = (scoreEast == scoreWest) ? "House" : (scoreEast > scoreWest ? "East" : "West")
        gameOver = true
    }

    func pause() {
        guard let fireDate = scheduledDate else { return }
        // Compute remaining
        let remaining = fireDate.timeIntervalSinceNow
        timeRemaining = max(remaining, 0)
        // Cancel pending work
        nextWorkItem?.cancel()
        scheduledDate = nil
    }

    func resume() {
        // Only if game not over and we have a remaining interval
        guard !gameOver, let remaining = timeRemaining else { return }
        scheduleNext(after: remaining)
        timeRemaining = nil
    }
}
