import SwiftUI




/*struct TrailDetailView: View {
    @ObservedObject var trailViewModel: TrailViewModel
    var trail: PopularTrail

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text(trail.trail_name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                // Additional details can be added here

            }
            .padding()
        }
    }
}*/


struct TrailCardView: View {
    var trail: PopularTrail
    var difficulty: DifficultyLevel?
    var difficultyViewModel: DifficultyViewModel

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
                        .frame(width: 239, height: 139)
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
            HStack{
                VStack(alignment: .leading, spacing: 8) {
                    Text(trail.trail_name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                     
                    
                    
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.orange)
                            .font(.subheadline)
                        Text(trail.area)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                        Spacer()
                    }
                    
                    HStack{
                        
                        VStack {
                            HStack{
                                Image(systemName: "calendar")
                                    .foregroundColor(.orange)
                                    .font(.subheadline)
                                Text("Duration:")
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                                    .font(.subheadline)
                                
                            }
                            Text("\(trail.days) days")
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                                .font(.subheadline)
                        }
                    
                        VStack {
                            HStack{
                                Image(systemName: "arrow.right.circle")
                                    .foregroundColor(.orange)
                                    .font(.subheadline)
                                Text("Distance:")
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                                    .font(.subheadline)
                                
                            }
                            Text(trail.distance)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 1, y: 1)
                                .font(.subheadline)
                            Spacer()
                        }
                }
                
                // Display difficulty level if available
                
            }
            .padding(10)
            .cornerRadius(10)
                
                difficulty.map {
                    Text($0.name)
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .font(.footnote)
                        .background(Color.white)
                        .padding(.top, 2)
                        .padding(.leading, 10)

                        
                }
            
        }
        }
        .shadow(radius: 5)
        .frame(width: 200, height: 120)
    }
}


struct TrailCardsScrollView: View {
    var trails: [PopularTrail]
    @ObservedObject var trailViewModel: TrailViewModel
    @ObservedObject var difficultyViewModel: DifficultyViewModel

    var body: some View {
        Text("Popular Trails")
            .font(.title)
            .fontWeight(.bold)
            .padding(.leading, 16)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(trails, id: \.trail_id) { trail in
                    if let difficulty = difficultyViewModel.difficultyLevels.first(where: { $0.difficulty_id == trail.trailDifficultyID }) {
        
                            TrailCardView(trail: trail, difficulty: difficulty, difficultyViewModel: difficultyViewModel)  // Pass 'difficultyViewModel'
                                .frame(width: 240, height: 130)
                                //.background(Color.red)
                                .padding(.trailing, 16)
                                .padding(.top, 16)
                                
                        
                    }
                }
            }
            .padding([.leading], 16)
        }
    }
}


struct trailView: View {
    @StateObject private var trailViewModel = TrailViewModel()
    @StateObject private var difficultyViewModel = DifficultyViewModel()

    var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    // Popular Trails Section
                    TrailCardsScrollView(trails: trailViewModel.trails, trailViewModel: trailViewModel, difficultyViewModel: difficultyViewModel)
                                        .navigationTitle("Popular Trails")
                                        .task {
                                            await trailViewModel.fetchData()
                                            await difficultyViewModel.fetchDifficultyLevels()  // Fetch difficulty levels
                                            
                                        }
                                        .padding(.bottom, 0)
                    // Multiday Trails Section
                    multView()
                    wkndView()
                    


                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        trailView()
    }
}
