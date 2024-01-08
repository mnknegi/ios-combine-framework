//
//  ViewModel.swift
//  BlogPost
//
//  Created by Mayank Negi on 08/01/24.
//

import Combine
import Foundation

final class ViewModel {

    @Published var isSubmitAllowed: Bool = false

    let blogPostPublisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)
        .map { (notification) -> String? in
            return (notification.object as? BlogPostViewModel)?.title ?? ""
        }
}
