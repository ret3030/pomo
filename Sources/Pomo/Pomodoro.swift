import Foundation

/// The 50/10 loop from pomo.sh. Remaining time is derived from a stored end date
/// rather than counted ticks, so the countdown stays correct across sleep and restarts.
struct Pomodoro: Codable, Equatable {
    enum Phase: String, Codable {
        case work
        case rest
    }

    static let workDuration: TimeInterval = 50 * 60
    static let restDuration: TimeInterval = 10 * 60

    var phase: Phase
    var endsAt: Date

    static func start(at now: Date) -> Pomodoro {
        Pomodoro(phase: .work, endsAt: now + workDuration)
    }

    func remaining(at now: Date) -> TimeInterval {
        max(0, endsAt.timeIntervalSince(now))
    }

    /// The following phase once this one is over, or nil while it still runs.
    /// Like pomo.sh, the next phase is timed from `now`, so after a long sleep
    /// you get a full phase instead of a skipped one.
    func next(at now: Date) -> Pomodoro? {
        guard now >= endsAt else { return nil }
        switch phase {
        case .work: return Pomodoro(phase: .rest, endsAt: now + Self.restDuration)
        case .rest: return Pomodoro(phase: .work, endsAt: now + Self.workDuration)
        }
    }

    /// Menu bar text such as "🍅 49:59". Rounds up so a fresh phase shows 50:00.
    func title(at now: Date) -> String {
        let seconds = Int(remaining(at: now).rounded(.up))
        let icon = phase == .work ? "🍅" : "☕"
        return String(format: "%@ %02d:%02d", icon, seconds / 60, seconds % 60)
    }
}
