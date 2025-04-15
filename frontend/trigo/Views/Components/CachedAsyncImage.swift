import SwiftUI
import Combine

// Enhanced image cache with memory management
class ImageCache {
    static let shared = ImageCache()
    private var cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100  // Maximum number of images
        cache.totalCostLimit = 1024 * 1024 * 50  // 50 MB
        return cache
    }()
    
    private init() {}
    
    func add(image: UIImage, for url: URL) {
        // Estimate the cost of the image (memory usage)
        let cost = image.jpegData(compressionQuality: 1.0)?.count ?? 0
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }
    
    func get(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func clear() {
        cache.removeAllObjects()
    }
}

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var loadedImage: UIImage?
    @State private var isLoading = true
    @State private var loadError: Error?
    
    init(url: URL?, scale: CGFloat = 1.0, @ViewBuilder content: @escaping (Image) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.scale = scale
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let loadedImage = loadedImage {
                content(Image(uiImage: loadedImage))
            } else {
                placeholder()
            }
        }
        .onAppear {
            loadImage()
        }
        .onChange(of: url) { _ in
            loadImage()
        }
    }
    
    private func loadImage() {
        // Reset state
        isLoading = true
        loadedImage = nil
        loadError = nil
        
        guard let url = url else {
            isLoading = false
            return
        }
        
        // Check cache first
        if let cachedImage = ImageCache.shared.get(for: url) {
            loadedImage = cachedImage
            isLoading = false
            return
        }
        
        // Set up the URLSession task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    print("Error loading image from \(url): \(error.localizedDescription)")
                    loadError = error
                    return
                }
                
                guard let data = data,
                      let image = UIImage(data: data) else {
                    print("Failed to create image from data at \(url)")
                    return
                }
                
                // Cache the image
                ImageCache.shared.add(image: image, for: url)
                loadedImage = image
            }
        }
        
        // Start the task
        task.resume()
    }
}

// Simplified version with default placeholder
extension CachedAsyncImage where Placeholder == ProgressView<EmptyView, EmptyView> {
    init(url: URL?, scale: CGFloat = 1.0, @ViewBuilder content: @escaping (Image) -> Content) {
        self.init(url: url, scale: scale, content: content) {
            ProgressView()
        }
    }
} 
