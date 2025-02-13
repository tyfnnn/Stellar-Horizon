//
//  BookmarkManager.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 13.02.25.
//

import Foundation

class BookmarkManager: ObservableObject {
    @Published private(set) var bookmarkedItems: Set<String> = []
    
    private let bookmarksKey = "bookmarkedItems"
    
    init() {
        loadBookmarks()
    }
    
    private func loadBookmarks() {
        if let data = UserDefaults.standard.object(forKey: bookmarksKey) as? Data {
            if let items = try? JSONDecoder().decode(Set<String>.self, from: data) {
                bookmarkedItems = items
            }
        }
    }
    
    private func saveBookmarks() {
        if let encoded = try? JSONEncoder().encode(bookmarkedItems) {
            UserDefaults.standard.set(encoded, forKey: bookmarksKey)
        }
    }
    
    func isBookmarked(_ itemId: String) -> Bool {
        bookmarkedItems.contains(itemId)
    }
    
    func toggleBookmark(for itemId: String) {
        if isBookmarked(itemId) {
            bookmarkedItems.remove(itemId)
        } else {
            bookmarkedItems.insert(itemId)
        }
        saveBookmarks()
    }
}
