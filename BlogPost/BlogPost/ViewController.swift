//
//  ViewController.swift
//  BlogPost
//
//  Created by Mayank Negi on 08/01/24.
//

import Combine
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var lastPostLbl: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    let viewModel = ViewModel()

    var subscribers: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         let subscriber = Subscribers.Assign(object: lastPostLbl, keyPath: \.text)
         viewModel.blogPostPublisher.subscribe(subscriber)
         */

/*
 The assign(to:on:) operator subscribes to the notification publisher and links its lifetime to the lifetime of the label. Once the label gets released, its subscription gets released too.
 */
       viewModel.blogPostPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: lastPostLbl)
            .store(in: &subscribers)

        viewModel.$isSubmitAllowed
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &subscribers)
    }

    @IBAction func postNotification(_ sender: Any) {
        let blogPostViewModel = BlogPostViewModel(title: "Getting started with the Combine framework in Swift", url: URL(string: "https://www.avanderlee.com/swift/combine/")!)
        NotificationCenter.default.post(name: .newBlogPost, object: blogPostViewModel)
    }

    @IBAction func toggle(_ sender: UISwitch) {
        viewModel.isSubmitAllowed = sender.isOn
    }
}

