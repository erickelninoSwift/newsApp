//
//  HomeController.swift
//  News App
//
//  Created by Erick El nino on 2022/11/03.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import SafariServices

class HomeController: UIViewController
{
    
    private let API_KEY = "e8772b0d460f47328230cef9da249306"
   static let cell_ID = "MyCell"
//    Tableview
//    Custom Cell
//    API CAller
//    Open the new story
//    Search for news
    
    private var viewModelCell = [NewsCellModel]()
    private var articles = [Article]()
     var tableview: UITableView =
    {
        let table = UITableView()
        table.register(NewsCell.self, forCellReuseIdentifier:NewsCell.cell_ID)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "News"
        view.backgroundColor = .systemBackground
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 150
        fetchAllData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cell_ID, for: indexPath) as? NewsCell
            
            else  { return UITableViewCell()
        }
        cell.configureCell(viewModel: viewModelCell[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedArticles = articles[indexPath.row]
        guard let url = URL(string: selectedArticles.url ?? "") else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }
    
    func fetchAllData()
    {
        APICaller.shared.getTopStories { [weak self] (Result) in
            switch Result
            {
            case .success(let myArticles):
                
                self?.articles = myArticles
                DispatchQueue.main.async {
                    
                    self?.viewModelCell = myArticles.compactMap({
                        NewsCellModel(viewModel: $0)
                    })
                    self?.tableview.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
