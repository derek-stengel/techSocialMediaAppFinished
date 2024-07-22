//
//  ViewController.swift
//  YearLongProject
//
//  Created by Derek Stengel on 2/29/24.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostCreationNotifcationDelegate {
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        configureRefreshControl()
        
        Task { @MainActor in
            do {
                try await PostsManager.shared.fetchPosts()
                self.table.reloadData()
            } catch {
                print("Failed to reload with posts.", error)
            }
        }
    }
    
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        self.table.refreshControl = UIRefreshControl()
        self.table.refreshControl?.addTarget(self, action:
                                        #selector(handleRefreshControl),
                                       for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        Task {
            do {
                try await PostsManager.shared.fetchPosts()
                self.table.reloadData()
            } catch {
                print("Failed to fetch posts:", error)
            }
            self.table.refreshControl?.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostsManager.shared.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        let post = PostsManager.shared.posts[indexPath.row]
        customCell.configure(with: post)
        
        return customCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        deletePost(at: indexPath)
    }
    
    func deletePost(at indexPath: IndexPath) {
        let post = PostsManager.shared.posts[indexPath.row]
        guard let userSecret = User.current?.secret else {
            print("User secret is not available")
            return
        }
        
        Task {
            do {
                try await PostsManager.shared.deletePost(postId: post.postid, userSecret: userSecret)
                DispatchQueue.main.async {
                    self.table.deleteRows(at: [indexPath], with: .automatic)
                }
            } catch {
                print("Failed to delete post:", error)
            }
        }
    }
    
    

    
//    func deletePost(at indexPath: IndexPath) {
//        let post = PostsManager.shared.posts[indexPath.row]
//        let userSecret = User.current?.secret.uuidString
//        
//        PostsManager.shared.deletePost(postId: post.postid, userSecret: userSecret) { result in
//            switch result {
//            case .success:
//                DispatchQueue.main.async {
//                    PostsManager.shared.posts.remove(at: indexPath.row)
//                    self.table.deleteRows(at: [indexPath], with: .automatic)
//                }
//            case .failure(let error):
//                print("Failed to delete post:", error)
//            }
//        }
//    }
    
    func editPost(post: Post) {
        let userSecret = UUID() // Replace with actual user secret
        
        PostsManager.shared.editPost(post: post, userSecret: userSecret) { result in
            switch result {
            case .success(let updatedPost):
                DispatchQueue.main.async {
                    if let index = PostsManager.shared.posts.firstIndex(where: { $0.postid == updatedPost.postid }) {
//                        PostsManager.shared.posts[index] = updatedPost
                        self.table.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    }
                }
            case .failure(let error):
                print("Failed to edit post:", error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NewPostViewController {
            destinationVC.delegate = self
            if let tabBarController = self.tabBarController,
               let viewControllers = tabBarController.viewControllers {
                for viewController in viewControllers {
                    if let navController = viewController as? UINavigationController,
                       let profileVC = navController.viewControllers.first as? MyProfileTableViewController {
                        destinationVC.profileDelegate = profileVC
                    }
                }
            }
        }
    }

    
    func didCreatePost(_ post: Post) {
        Task {
//            do {
                self.table.reloadData()
//            } catch {
//                print("Failed to create post.")
//            }
        }
    }
}

//        PostsManager.shared.posts.append(post)
