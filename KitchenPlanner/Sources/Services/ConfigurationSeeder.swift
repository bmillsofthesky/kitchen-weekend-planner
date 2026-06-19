import Foundation
import SwiftData

@MainActor
final class ConfigurationSeeder {
    static func seedIfNeeded(context: ModelContext) {
        seed(from: "movements", in: Bundle.main, context: context)
    }

    static func importFromData(_ data: Data, context: ModelContext) throws {
        let dtos = try JSONDecoder().decode([MovementConfigurationDTO].self, from: data)
        upsert(dtos: dtos, context: context)
    }

    private static func seed(from resource: String, in bundle: Bundle, context: ModelContext) {
        guard let url = bundle.url(forResource: resource, withExtension: "json") else {
            print("[Seeder] movements.json not found in bundle")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let dtos = try JSONDecoder().decode([MovementConfigurationDTO].self, from: data)
            upsert(dtos: dtos, context: context)
        } catch {
            print("[Seeder] Failed to load movements.json: \(error)")
        }
    }

    private static func upsert(dtos: [MovementConfigurationDTO], context: ModelContext) {
        let existing = (try? context.fetch(FetchDescriptor<MovementConfiguration>())) ?? []
        let existingById = Dictionary(uniqueKeysWithValues: existing.map { ($0.id, $0) })

        for dto in dtos {
            if let existing = existingById[dto.id] {
                existing.name = dto.name
                existing.abbr = dto.abbr
                existing.headcount = dto.headcount
                existing.budget = dto.budget
                existing.exportEmail = dto.exportEmail
                existing.recipesUrl = dto.recipesUrl
                existing.days = dto.days
            } else {
                let config = MovementConfiguration(
                    id: dto.id, name: dto.name, abbr: dto.abbr,
                    headcount: dto.headcount, budget: dto.budget,
                    exportEmail: dto.exportEmail, recipesUrl: dto.recipesUrl,
                    days: dto.days
                )
                context.insert(config)
            }
        }
        do {
            try context.save()
            print("[Seeder] Saved \(dtos.count) movement(s)")
        } catch {
            print("[Seeder] Save failed: \(error)")
        }
    }
}
