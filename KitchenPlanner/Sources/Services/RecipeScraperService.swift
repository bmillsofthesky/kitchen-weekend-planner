import Foundation
import WebKit

@MainActor
final class RecipeScraperService: NSObject {
    private var webView: WKWebView?
    private var continuation: CheckedContinuation<RecipeDTO?, Never>?

    func scrape(url: URL) async -> RecipeDTO? {
        await withCheckedContinuation { cont in
            self.continuation = cont

            let config = WKWebViewConfiguration()
            let wv = WKWebView(frame: .zero, configuration: config)
            wv.navigationDelegate = self
            self.webView = wv

            wv.load(URLRequest(url: url))
        }
    }

    private func extractRecipe() {
        let js = """
        (function() {
            var scripts = document.querySelectorAll('script[type="application/ld+json"]');
            for (var s of scripts) {
                try {
                    var obj = JSON.parse(s.textContent);
                    var items = Array.isArray(obj) ? obj : (obj['@graph'] || [obj]);
                    for (var item of items) {
                        if (item['@type'] === 'Recipe') {
                            return JSON.stringify(item);
                        }
                    }
                } catch(e) {}
            }
            return null;
        })();
        """
        webView?.evaluateJavaScript(js) { [weak self] result, _ in
            guard let self else { return }
            let dto: RecipeDTO?
            if let jsonString = result as? String,
               let data = jsonString.data(using: .utf8) {
                dto = try? JSONDecoder().decode(SchemaRecipeDTO.self, from: data).toRecipeDTO()
            } else {
                dto = nil
            }
            self.continuation?.resume(returning: dto)
            self.continuation = nil
            self.webView = nil
        }
    }
}

extension RecipeScraperService: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        extractRecipe()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        continuation?.resume(returning: nil)
        continuation = nil
        self.webView = nil
    }
}

// MARK: - Schema.org Recipe DTO

private struct SchemaRecipeDTO: Codable {
    var name: String?
    var description: String?
    var recipeIngredient: [String]?
    var recipeInstructions: SchemaInstructions?
    var recipeYield: SchemaYield?

    enum CodingKeys: String, CodingKey {
        case name, description, recipeIngredient, recipeInstructions, recipeYield
    }

    func toRecipeDTO() throws -> RecipeDTO {
        let ingredients = (recipeIngredient ?? []).map { raw -> IngredientDTO in
            let parts = raw.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            let amount = parts.first.flatMap { Double($0) }
            let measurement = parts.count > 1 ? parts[1] : ""
            let name = parts.dropFirst(2).joined(separator: " ")
            return IngredientDTO(name: name.isEmpty ? raw : name,
                                 measurement: measurement, amount: amount, section: nil)
        }
        let directions = recipeInstructions?.steps.enumerated().map { i, text in
            DirectionDTO(order: i + 1, text: text, section: nil)
        } ?? []

        return RecipeDTO(
            id: UUID().uuidString,
            title: name ?? "Untitled",
            description: description,
            costForRecipe: nil,
            servingSize: recipeYield?.intValue,
            type: nil,
            labels: nil,
            ingredients: ingredients,
            directions: directions,
            notes: nil,
            sourceURL: nil
        )
    }
}

private enum SchemaYield: Codable {
    case string(String)
    case array([String])

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let s = try? c.decode(String.self) { self = .string(s) }
        else if let a = try? c.decode([String].self) { self = .array(a) }
        else { self = .string("") }
    }

    func encode(to encoder: Encoder) throws {}

    var intValue: Int? {
        switch self {
        case .string(let s): return Int(s.components(separatedBy: .whitespaces).first ?? "")
        case .array(let a): return Int(a.first?.components(separatedBy: .whitespaces).first ?? "")
        }
    }
}

private struct SchemaInstructions: Codable {
    var steps: [String]

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let arr = try? c.decode([SchemaStep].self) {
            steps = arr.map { $0.text }
        } else if let arr = try? c.decode([String].self) {
            steps = arr
        } else {
            steps = []
        }
    }

    func encode(to encoder: Encoder) throws {}
}

private struct SchemaStep: Codable {
    var text: String
}
