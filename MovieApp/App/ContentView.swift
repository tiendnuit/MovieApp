import SwiftUI
import Playgrounds

struct ContentView: View {
    let container: AppContainer
    @State private var router = AppRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView(viewModel: container.makeHomeViewModel(), onSelected: router.showDetail(for:))
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .movieDetail(let movie):
                        MovieDetailView(
                            viewModel: container.makeMovieDetailViewModel(movie: movie)
                        )
                    }
                }
        }
    }
}
