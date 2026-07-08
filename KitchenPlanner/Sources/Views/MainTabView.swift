import SwiftUI

struct MainTabView: View {
    var plan: WeekendPlan
    var movement: MovementConfiguration

    var body: some View {
        TabView {
            NavigationStack {
                PlanOverviewView(plan: plan, movement: movement)
            }
            .tabItem { Label("Plan", systemImage: "calendar") }

            NavigationStack {
                RecipeLibraryView(movement: movement)
            }
            .tabItem { Label("Recipes", systemImage: "book.fill") }

            NavigationStack {
                SettingsView(plan: plan, movement: movement)
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}
