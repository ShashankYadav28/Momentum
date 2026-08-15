
import SwiftUI

@main
struct MomentumApp: App {
    
    @State private var appContainer:AppDIContainer?
    
//    init() {
//        do {
//            appContainer = try  AppDIContainer()
//        } catch {
//            print("App Initialisation Failed \(error)")
//            self.appContainer = nil
//        }
//    }
//    
   
    var body: some Scene {
        WindowGroup {
            Group {
                if let appContainer {
                    HomeScreen()
                        .environmentObject(appContainer.taskViewModel)
                } else {
                    RecoveryScreen {
                        startApp()
                    }
                }
            }
            .task {
                if appContainer == nil {
                    startApp()
                }
            }
        }
    }
    
    private func startApp() {
        do {
            appContainer = try AppDIContainer()
        } catch {
            print("App Initialisation Failed \(error)")
            self.appContainer = nil
        }
    }
    
}
