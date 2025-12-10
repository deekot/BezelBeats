import SwiftUI
import AppKit

@main
struct BezelBeatsApp: App {
    @StateObject private var audio = AudioEngine()
    
    // Global hotkey monitor
    @State private var isVisible = true
    
    var body: some Scene {
        WindowGroup {
            ContentView(audio: audio)
                .background(Color.clear)
                .onAppear {
                    setupWindow()
                    setupHotkey()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
    
    func setupWindow() {
        // Delay slightly to let the window spawn
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let window = NSApplication.shared.windows.first {
                window.level = .screenSaver // Floats above everything
                window.isOpaque = false
                window.backgroundColor = .clear
                window.hasShadow = false
                window.ignoresMouseEvents = true // Click-through
                
                // Stretch to full screen
                if let screen = NSScreen.main {
                    window.setFrame(screen.frame, display: true)
                }
                
                // Allow it to float over full-screen apps
                window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            }
        }
    }
    
    func setupHotkey() {
        // Simple global monitor for Cmd+Opt+D
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains([.command, .option]) && event.keyCode == 2 { // 'D' key
                toggleVisibility()
            }
        }
    }
    
    func toggleVisibility() {
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                if window.alphaValue > 0 {
                    window.alphaValue = 0
                } else {
                    window.alphaValue = 1
                }
            }
        }
    }
}
