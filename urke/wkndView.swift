import SwiftUI

struct weekendTrails: Codable {
    var trail_id: String
    var trail_name: String
    var description: String
    var images: [TrailImage]
    var area: String
    var days: String
    var distance: String
    var state: String
    var country: String
    
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
    }
}


struct weekndTrailCardView: View {
    var trail: weekendTrails

    var body: some View {
        ZStack(alignment: .topLeading) {
            AsyncImage(url: URL(string: trail.images.first?.image_name ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 120) // Set a fixed size for the image
                        .clipped()
                        .cornerRadius(10)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(minHeight: 40, maxHeight: 120)
                        .clipped()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(trail.trail_name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow for readability

                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.orange)
                    Text(trail.area)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow
                    Spacer()
                }

                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.orange)
                    Text("Duration:")
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow
                    Text("\(trail.days) days")
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow
                }

                HStack {
                    Image(systemName: "arrow.right.circle")
                        .foregroundColor(.orange)
                    Text("Distance:")
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow
                    Text(trail.distance)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1) // Add shadow
                    Spacer()
                }
            }
            .padding(10)
            .cornerRadius(10)
        }
        .shadow(radius: 5)
        .frame(width: 200, height: 120)
    }
}

struct weekndCardsScrollView: View {
    var trails: [weekendTrails]


    var body: some View {
        Text("Weekend Trails")
            .font(.title)
            .fontWeight(.bold)
            .padding(.leading, 16)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(trails, id: \.trail_id) { trail in
                        weekndTrailCardView(trail: trail)
                            .frame(width: 200, height: 130)
                            .padding(.trailing, 16)
                    
                }
            }
            .padding([.leading], 16)
        }
    }
}
struct wkndView: View {
    @State private var weekendtreyls = [weekendTrails]()

    var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    // Popular Trails Section
                    weekndCardsScrollView(trails: weekendtreyls)
                        .navigationTitle("Popular Trails")
                        .task {
                            await fetchData()
                        }
                        .padding(.bottom, 0)



                }
            }
    }

    private func fetchData() async {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/weekendTrailsExploreAll?start=0") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let result = json?["result"] as? [[String: Any]] {
                let decodedResponse = try JSONDecoder().decode([weekendTrails].self, from: JSONSerialization.data(withJSONObject: result))
                weekendtreyls = decodedResponse
            } else {
                print("Error: Unable to extract 'result' key from JSON")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

#Preview {
    wkndView()
}

