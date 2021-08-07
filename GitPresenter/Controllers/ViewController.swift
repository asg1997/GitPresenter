//
//  ViewController.swift
//  GitPresenter
//
//  Created by Максим on 05.08.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private let pageLimit = 10
    private var currentLastId: Int? = nil
    
    private var repositories = [Repository]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private enum TableSection: Int {
        case repoList
        case loader
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupData()
    }

    
    private func setupView() {
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    private func setupData() {
        GithubAPIManager.shared.getRepositories { result in
            if result != nil {
                self.repositories = result!
                self.currentLastId = result!.last?.id
            } else {
                print("fetching data error")
            }
            
        }
    }
    
    private func fetchData(completed: ((Bool) -> Void)? = nil) {
        GithubAPIManager.shared.getRepositories(sinceId: currentLastId) { result in
            guard result != nil else {
                print("repos not fetched")
                completed?(false)
                return }
            
            self.repositories.append(contentsOf: result!)
            // обновит только последние результаты
            self.currentLastId = result!.last?.id
            completed?(true)
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    private func hideBottomLoader() {
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: self.repositories.count - 1, section: TableSection.repoList.rawValue)
            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
}




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let listSection = TableSection(rawValue: section) else { return 0 }
        switch listSection {
        case .repoList:
            return repositories.count
        case .loader:
            return repositories.count >= pageLimit ? 1 : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as?  TableViewCell else { return UITableViewCell() }
        
        switch section {
        case .repoList:
            let repo = repositories[indexPath.row]
            cell.configure(repository: repo)
            
        case .loader:
            cell.loader()
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else { return }
        guard !repositories.isEmpty else { return }
        
        if section == .loader {
            print("load new data..")
            fetchData { success in
                if !success {
                    self.hideBottomLoader()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Identifier.webViewSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.webViewSegue {
            guard let row = tableView.indexPathForSelectedRow?.row else { return }
            guard row < repositories.count - 1 else { return }
            
            let webVC = segue.destination as! WebViewController
            webVC.repoUrl = repositories[row].htmlUrl
            
        }
    }

}

extension ViewController {
    
    
    @objc private func refreshData(_ sender: Any) {
        fetchData()
    }
}

