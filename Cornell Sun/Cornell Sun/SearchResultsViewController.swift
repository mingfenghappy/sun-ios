//
//  SearchResultsViewController.swift
//  Cornell Sun
//
//  Created by Chris Sciavolino on 9/20/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    var query: String = ""
    var searchResults: [String] = []
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        navigationItem.title = "Search Results for \"\(query)\""

        // Set up table view to show all results -- This could become a collection view if necessary
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        // Make API request to cornellsun with query
        API.request(target: .searchPosts(query: query), success: { (response) in
            do {
                // Parse successful response
                let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: [])
                if let postArray = jsonResult as? [[String: Any]] {
                    // For each article in the response
                    for postDictionary in postArray {
                        guard
                            let links = postDictionary["_links"] as? [String: Any],
                            let titleDictionary = postDictionary["title"] as? [String: Any]?,
                            let title = titleDictionary!["rendered"] as? String,
                            let media = links["wp:featuredmedia"] as? [[String: Any]],
                            var _ = media[0]["href"] as? String
                            else {
                                return
                        }
                        // As of right now, just append title to searchResults
                        self.searchResults.append(title)
                    }
                    // After iterating through all the articles, reload tableView
                    self.tableView.reloadData()
                }
            } catch {
                // Unable to parse response
                print("Unable to parse successful response.")
            }
        }, error: { (error) in
            // Error from Wordpress
            print("Error in request to Wordpress: \(error.localizedDescription)")
        }, failure: { (_) in
            // Show Moya error
            print("Error with Moya submitting request.")
        })
    }
}

extension SearchResultsViewController: UITableViewDelegate {

}

extension SearchResultsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
}
