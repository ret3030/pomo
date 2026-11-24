import AppKit
import ServiceManagement
import UserNotifications

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate, UNUserNotificationCenterDelegate {
    private static let stateKey = "pomodoro"

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var ticker: Timer?
    private var pomodoro: Pomodoro?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem.button?.font = .monospacedDigitSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        let menu = NSMenu()
        menu.delegate = self
        statusItem.menu = menu

        let notifications = UNUserNotificationCenter.current()
        notifications.delegate = self
        notifications.requestAuthorization(options: [.alert, .sound]) { _, _ in }

        if let data = UserDefaults.standard.data(forKey: Self.stateKey) {
            pomodoro = try? JSONDecoder().decode(Pomodoro.self, from: data)
        }
        if pomodoro != nil { startTicking() }
        tick()
    }

    // Rebuilt only when opened, so the per-second tick never touches the menu.
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()
        if pomodoro == nil {
            menu.addItem(item("Start", #selector(start)))
        } else {
            menu.addItem(item("Stop", #selector(stop)))
        }
        menu.addItem(.separator())
        let login = item("Launch at Login", #selector(toggleLaunchAtLogin))
        login.state = SMAppService.mainApp.status == .enabled ? .on : .off
        menu.addItem(login)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit Pomo", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }

    private func item(_ title: String, _ action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        return item
    }

    @objc private func start() {
        update(Pomodoro.start(at: .now))
        notify("Focus session started: 50 min")
        startTicking()
        tick()
    }

    @objc private func stop() {
        ticker?.invalidate()
        ticker = nil
        update(nil)
        tick()
    }

    @objc private func toggleLaunchAtLogin() {
        let service = SMAppService.mainApp
        do {
            if service.status == .enabled {
                try service.unregister()
            } else {
                try service.register()
            }
        } catch {
            NSApp.activate(ignoringOtherApps: true)
            NSAlert(error: error).runModal()
        }
    }

    private func startTicking() {
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated { self?.tick() }
        }
        // Lets macOS batch wake-ups with other work; a 0.1 s jitter is invisible.
        timer.tolerance = 0.1
        // .common keeps the countdown running while the menu is open.
        RunLoop.main.add(timer, forMode: .common)
        ticker = timer
    }

    private func tick() {
        if let next = pomodoro?.next(at: .now) {
            update(next)
            notify(next.phase == .rest ? "Work session done, take a break!" : "Break's over, back to work!")
        }
        statusItem.button?.title = pomodoro?.title(at: .now) ?? "🍅"
    }

    private func update(_ new: Pomodoro?) {
        pomodoro = new
        let data = new.flatMap { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: Self.stateKey)
    }

    private func notify(_ text: String) {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro"
        content.body = text
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
        NSSound(named: "Glass")?.play()
    }

    // Without this, banners are suppressed whenever the app counts as active.
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        .banner
    }
}

let delegate = AppDelegate()
NSApplication.shared.delegate = delegate
NSApplication.shared.run()
