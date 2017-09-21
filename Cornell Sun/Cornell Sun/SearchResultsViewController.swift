//
//  SearchResultsViewController.swift
//  Cornell Sun
//
//  Created by Chris Sciavolino on 9/20/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    var query: String?
    var searchResults: [String] = []
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if query == nil {
            query = ""
        }

        self.view.backgroundColor = .white
        navigationItem.title = "Search Results for \"\(query!)\""
        print("About to make API Request")
        API.request(target: .searchPosts(query: query!), success: { (response) in
            // parse your data
            print("In Successful")
            print(response)
//            do {
//                // parse response
//            } catch {
//                print("could not parse")
//                // can't parse data, show error
//            }
        }, error: { (error) in
            // error from Wordpress
            print("In Error Block")
            print(error)
            print(error.localizedDescription)
        }, failure: { (_) in
            // show Moya error
            print("In Moya error block")
        })

        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
