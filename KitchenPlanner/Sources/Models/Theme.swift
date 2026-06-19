import Foundation
import SwiftData

struct NeededItem: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var quantity: String
    var link: String?
}

struct Skit: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var details: String
}

@Model
final class Theme {
    var title: String
    var coverImageData: Data?       // raw PNG/JPEG data for cover
    var themeDescription: String
    var designDetails: String
    var neededItemsData: Data       // JSON [NeededItem]
    var skitsData: Data             // JSON [Skit]
    var referenceImagesData: [Data] // raw image data list

    var neededItems: [NeededItem] {
        get { (try? JSONDecoder().decode([NeededItem].self, from: neededItemsData)) ?? [] }
        set { neededItemsData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    var skits: [Skit] {
        get { (try? JSONDecoder().decode([Skit].self, from: skitsData)) ?? [] }
        set { skitsData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    init(title: String = "", description: String = "", designDetails: String = "") {
        self.title = title
        self.themeDescription = description
        self.designDetails = designDetails
        self.neededItemsData = (try? JSONEncoder().encode([NeededItem]())) ?? Data()
        self.skitsData = (try? JSONEncoder().encode([Skit]())) ?? Data()
        self.referenceImagesData = []
    }
}
