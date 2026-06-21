import Foundation

private let cookingUnits: [String] = [
    "cups", "cup",
    "tablespoons", "tablespoon", "tbsp",
    "teaspoons", "teaspoon", "tsp",
    "ounces", "ounce", "oz",
    "pounds", "pound", "lbs", "lb",
    "grams", "gram",
    "kilograms", "kilogram", "kg",
    "milliliters", "milliliter", "ml",
    "sticks", "stick",
    "whole",
    "cloves", "clove",
    "sprigs", "sprig",
    "cans", "can",
    "packages", "package",
    "bunches", "bunch",
    "pieces", "piece",
    "pinches", "pinch",
    "dashes", "dash",
]

private let scalingRegex: NSRegularExpression? = {
    let unitPattern = cookingUnits
        .sorted { $0.count > $1.count }
        .map { NSRegularExpression.escapedPattern(for: $0) }
        .joined(separator: "|")
    let pattern = "(\\d+(?:\\.\\d+)?)\\s*(\(unitPattern))(?=\\s|[.,;!?]|$)"
    return try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
}()

func scaleDirectionText(_ text: String, ratio: Double) -> String {
    guard ratio != 1.0, let regex = scalingRegex else { return text }

    let nsText = text as NSString
    let fullRange = NSRange(location: 0, length: nsText.length)
    let matches = regex.matches(in: text, range: fullRange)

    guard !matches.isEmpty else { return text }

    let mutable = NSMutableString(string: text)
    var offset = 0

    for match in matches {
        let numberRange = NSRange(location: match.range(at: 1).location + offset,
                                  length: match.range(at: 1).length)
        let numberString = mutable.substring(with: numberRange)
        guard let original = Double(numberString) else { continue }

        let scaled = original * ratio
        let replacement: String
        if scaled == scaled.rounded() && !scaled.isInfinite {
            replacement = "\(Int(scaled.rounded()))"
        } else {
            replacement = String(format: "%.2f", scaled)
        }

        mutable.replaceCharacters(in: numberRange, with: replacement)
        offset += replacement.count - numberRange.length
    }

    return mutable as String
}
