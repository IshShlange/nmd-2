import SwiftUI

struct UnsplashSearchView: View {
    @StateObject private var viewModel = UnsplashSearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Поисковая строка
                HStack {
                    TextField("Search photos...", text: $viewModel.query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                    
                    Button("Search") {
                        Task {
                            await viewModel.search()
                        }
                    }
                    .disabled(viewModel.query.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                // Состояния
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading...")
                    Spacer()
                } else if let error = viewModel.errorText {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else if viewModel.photos.isEmpty && !viewModel.query.isEmpty {
                    Spacer()
                    Text("No results found")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    // Список результатов
                    List(viewModel.photos) { photo in
                        VStack(alignment: .leading, spacing: 8) {
                            // Изображение
                            AsyncImage(url: URL(string: photo.urls.small)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(height: 200)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 200)
                                        .cornerRadius(8)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 200)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                            // Информация
                            Text("By \(photo.user.name)")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                Text("\(photo.likes)")
                            }
                            .font(.subheadline)
                            
                            // Ссылка на автора
                            if let url = viewModel.photographerURL(for: photo) {
                                Link("View photographer", destination: url)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Unsplash Search")
        }
    }
}