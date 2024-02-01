import SwiftUI

class TrailViewModel: ObservableObject {
    @Published var trails: [PopularTrail] = []
    @Published var selectedTrail: PopularTrail?

    func fetchData() async {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/popularTrailsExploreAll?start=0") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let result = json?["result"] as? [[String: Any]] {
                let decodedResponse = try JSONDecoder().decode([PopularTrail].self, from: JSONSerialization.data(withJSONObject: result))
                trails = decodedResponse
            } else {
                print("Error: Unable to extract 'result' key from JSON")
            }
        } catch {
            print("Error: \(error)")
        }
    }

    func selectTrail(_ trail: PopularTrail) {
        selectedTrail = trail
    }
}

struct PopularTrail: Codable {
    var trail_id: String
    var trail_name: String
    var description: String
    var images: [TrailImage]
    var area: String
    var days: String
    var distance: String
    var state: String
    var country: String
    var trailDifficultyID: String  // Updated property name for clarity

    struct TrailImage: Codable {
        var image_name: String
    }

    enum CodingKeys: String, CodingKey {
        case trail_id
        case trail_name
        case description
        case images
        case area
        case days
        case distance
        case state
        case country
        case trailDifficultyID = "difficulty_id"  // Match with the server response
    }
}

class DifficultyViewModel: ObservableObject {
    @Published var difficultyLevels: [DifficultyLevel] = []

    func fetchDifficultyLevels() async {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/getDifficultyLevels?difficulty_id=0") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let result = json?["result"] as? [[String: Any]] {
                let decodedResponse = try JSONDecoder().decode([DifficultyLevel].self, from: JSONSerialization.data(withJSONObject: result))
                difficultyLevels = decodedResponse
            } else {
                print("Error: Unable to extract 'result' key from JSON")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

struct DifficultyLevel: Codable {
    var difficulty_id: String
    var name: String
}



class MultidayTrailsViewModel: ObservableObject {
    @Published var multidayTrails: [MultidayTrail] = []
    @Published var selectedMultidayTrail: MultidayTrail?

    func fetchData() async {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/multiDayTrailsExploreAll?start=0") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let result = json?["result"] as? [[String: Any]] {
                let decodedResponse = try JSONDecoder().decode([MultidayTrail].self, from: JSONSerialization.data(withJSONObject: result))
                multidayTrails = decodedResponse
            } else {
                print("Error: Unable to extract 'result' key from JSON")
            }
        } catch {
            print("Error: \(error)")
        }
    }

    func selectMultidayTrail(_ multidayTrail: MultidayTrail) {
        selectedMultidayTrail = multidayTrail
    }
}

struct MultidayTrail: Codable {
    var trail_id: String
    var trail_name: String
    var description: String
    var images: [TrailImage]
    var area: String
    var days: String
    var distance: String
    var state: String
    var country: String
    var trailDifficultyID: String

    struct TrailImage: Codable {
        var image_name: String
    }

    enum CodingKeys: String, CodingKey {
        case trail_id
        case trail_name
        case description
        case images
        case area
        case days
        case distance
        case state
        case country
        case trailDifficultyID
    }
}

