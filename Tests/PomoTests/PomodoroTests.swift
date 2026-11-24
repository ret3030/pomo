import Foundation
import Testing
@testable import Pomo

let t0 = Date(timeIntervalSinceReferenceDate: 0)

@Test func startsWithFiftyMinutesOfWork() {
    let pomodoro = Pomodoro.start(at: t0)
    #expect(pomodoro.phase == .work)
    #expect(pomodoro.title(at: t0) == "🍅 50:00")
    #expect(pomodoro.title(at: t0 + 1) == "🍅 49:59")
}

@Test func roundsPartialSecondsUp() {
    #expect(Pomodoro.start(at: t0).title(at: t0 + 0.4) == "🍅 50:00")
}

@Test func keepsPhaseUntilItEnds() {
    #expect(Pomodoro.start(at: t0).next(at: t0 + 50 * 60 - 1) == nil)
}

@Test func workIsFollowedByTenMinuteBreak() throws {
    let rest = try #require(Pomodoro.start(at: t0).next(at: t0 + 50 * 60))
    #expect(rest.phase == .rest)
    #expect(rest.title(at: t0 + 50 * 60) == "☕ 10:00")
}

@Test func breakIsFollowedByWork() throws {
    let rest = Pomodoro(phase: .rest, endsAt: t0)
    let work = try #require(rest.next(at: t0))
    #expect(work == Pomodoro.start(at: t0))
}

@Test func nextPhaseAfterSleepStartsFromWakeUp() throws {
    let wake = t0 + 3 * 60 * 60
    let rest = try #require(Pomodoro.start(at: t0).next(at: wake))
    #expect(rest.endsAt == wake + 10 * 60)
}

@Test func remainingNeverGoesNegative() {
    let pomodoro = Pomodoro.start(at: t0)
    #expect(pomodoro.remaining(at: t0 + 2 * 60 * 60) == 0)
    #expect(pomodoro.title(at: t0 + 2 * 60 * 60) == "🍅 00:00")
}

@Test func survivesSaveAndLoad() throws {
    let pomodoro = Pomodoro(phase: .rest, endsAt: t0 + 123)
    let data = try JSONEncoder().encode(pomodoro)
    #expect(try JSONDecoder().decode(Pomodoro.self, from: data) == pomodoro)
}
