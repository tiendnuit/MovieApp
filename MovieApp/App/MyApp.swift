import SwiftUI

@main struct MyApp: App {
    @State private var container = AppContainer.live()
    
    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
