import SwiftUI

struct ContentView: View {
    @ObservedObject var audio: AudioEngine
    
    // Start time for animation
    let startDate = Date()
    
    var body: some View {
        TimelineView(.animation) { context in
            Rectangle()
                .foregroundStyle(.clear)
                // Use the Metal Shader
                .colorEffect(ShaderLibrary.fluidShader(
                    .float(context.date.timeIntervalSince(startDate)),
                    .float(audio.amplitude),
                    .float2(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
                ))
                .ignoresSafeArea()
        }
    }
}

// Helper to access screen size
extension UIScreen {
    static let main = NSScreen.main!
}

extension NSScreen {
    var bounds: CGRect { frame }
}
