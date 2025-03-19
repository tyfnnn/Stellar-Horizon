//
//  FeedLoader.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 10.02.25.
//

import Foundation
import FeedKit

@Observable
class FeedLoader {
    var items = [FeedItem]()
    var isLoading = false
    var error: String?

    func loadAllFeeds() {
        isLoading = true
        error = nil
        items.removeAll()

        let dispatchGroup = DispatchGroup()
        
        for category in FeedCategory.allCategories {
            for subcategory in category.subcategories {
                dispatchGroup.enter()
                loadFeed(for: subcategory.url) {
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
        }
    }

    private func loadFeed(for url: URL, completion: @escaping () -> Void) {
        let parser = FeedParser(URL: url)
        parser.parseAsync { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let feed):
                    self?.handleFeed(feed: feed, subcategoryURL: url)
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
                completion()
            }
        }
    }

    private func handleFeed(feed: Feed, subcategoryURL: URL) {
        guard let rssFeed = feed.rssFeed else { return }

        let newItems: [FeedItem] = rssFeed.items?.compactMap { item in
            guard let title = item.title,
                  let description = item.description,
                  let pubDate = item.pubDate,
                  let linkString = item.link,
                  let link = URL(string: linkString) else { return nil }
            
            var imageURL: URL? = nil
            
            if let content = item.content?.contentEncoded {
                imageURL = extractFirstImageURL(from: content)
            } else if let description = item.description {
                imageURL = extractFirstImageURL(from: description)
            }

            return FeedItem(
                title: title,
                description: description.strippingHTML(), 
                pubDate: pubDate,
                link: link,
                subcategoryURL: subcategoryURL,
                imageURL: imageURL
            )
        } ?? []

        items.append(contentsOf: newItems)
    }
    
    // Hilfsfunktion zum Extrahieren der ersten Bild-URL aus HTML
    private func extractFirstImageURL(from htmlString: String) -> URL? {
        // Versuche zuerst src mit https zu finden
        let patterns = [
            #"<img[^>]+src=\"(https://[^\"]+)\""#,
            #"<img[^>]+src=\"(http://[^\"]+)\""#,
            #"<img[^>]+src=\"([^\"]+)\""#
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: htmlString, range: NSRange(htmlString.startIndex..., in: htmlString)),
               let range = Range(match.range(at: 1), in: htmlString) {
                let urlString = String(htmlString[range])
                if let url = URL(string: urlString) {
                    return url
                }
            }
        }
        return nil
    }
}
