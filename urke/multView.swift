import SwiftUI

struct multidayTrails: Codable {
    var trail_id: String
    var trail_name: String
    var description: String
    var images: [TrailImage]
    var area: String
    var days: String
    var distance: String
    var state: String
    var country: String
    
    struct TrailImage: Codable{
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

struct multrailCardView: View {
    var trail: multidayTrails
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AsyncImage(url: URL(string: trail.images.first?.image_name ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 110) // Slightly smaller square image
                        .clipped()
                        .cornerRadius(8) // Adjusted corner radius
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100) // Slightly smaller square image
                        .clipped()
                        .cornerRadius(8) // Adjusted corner radius
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2) // Outline of the card
                        )
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(trail.trail_name)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.orange)
                    Text(trail.area)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.orange)
                    Text("Duration:")
                        .foregroundColor(.black)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                    Text("\(trail.days) days")
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                }
                
                HStack {
                    Image(systemName: "arrow.right.circle")
                        .foregroundColor(.orange)
                    Text("Distance:")
                        .foregroundColor(.black)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                    Text(trail.distance)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                    Spacer()
                }
            }
            .padding(8)
        }
        .background(Color.white) // Set your desired background color
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8) // Slightly reduced vertical padding
    }
}





struct multrailCardsScrollView: View {
    var trails: [multidayTrails]

    var body: some View {
        ScrollView {
            ForEach(trails, id: \.trail_id) { trail in
                multrailCardView(trail: trail)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16)
            }
            .padding([.leading, .trailing], 16)
        }
    }
}







struct multView: View {
    @State private var multtreyls = [multidayTrails]()

    var body: some View {
        VStack {
            Text("Multi-day Trails")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 16)
                            .padding(.top, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(multtreyls.prefix(5), id: \.trail_id) { trail in
                multrailCardView(trail: trail)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16)
            }
            .padding([.leading, .trailing], 16)
        }
        .navigationTitle("Multiday Trails")
        .task {
            await fetchData()
        }
    }

    private func fetchData() async {
        guard let url = URL(string: "https://app.trooperworld.com/php/trooper/index.php/web_services/Services/multiDayTrailsExploreAll?start=0") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let result = json?["result"] as? [[String: Any]] {
                let decodedResponse = try JSONDecoder().decode([multidayTrails].self, from: JSONSerialization.data(withJSONObject: result))
                multtreyls = decodedResponse
            } else {
                print("Error: Unable to extract 'result' key from JSON")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}


#Preview {
    multView()
}
