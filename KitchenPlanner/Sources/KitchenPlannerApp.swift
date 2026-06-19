import SwiftUI
import SwiftData

@main
struct KitchenPlannerApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for:
                MovementConfiguration.self,
                WeekendPlan.self,
                MealPlan.self,
                RecipeAssignment.self,
                Recipe.self,
                Theme.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .onAppear {
                    ConfigurationSeeder.seedIfNeeded(context: container.mainContext)
                }
        }
    }
}
