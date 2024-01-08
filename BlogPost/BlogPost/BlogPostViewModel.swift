//
//  BlogPostViewModel.swift
//  BlogPost
//
//  Created by Mayank Negi on 08/01/24.
//

import Foundation

struct BlogPostViewModel {
    let title: String
    let url: URL
}

extension Notification.Name {
    static let newBlogPost = Notification.Name("new_blog_post")
}
