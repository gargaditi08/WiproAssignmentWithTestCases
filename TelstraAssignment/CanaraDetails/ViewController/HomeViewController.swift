//
//  HomeViewController.swift
//  TelstraAssignment
//
//  Created by Aditi Garg on 16/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //check reachability
    var reachability : Reachability? = Reachability.networkReachabilityForInternetConnection()
    var tableView = UITableView()
    var updatecell = UpdateTableViewCell()
    var viewModel = UpdatesViewModel()
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotification), object: nil)
        _ = reachability?.startNotifier()
        self.view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        self.tableViewSetup()
        self.getViewModelData()
        
    }
    //refresing Table Data
    @objc private func refreshTableData(_ sender: Any)
    {
        self.viewModel.getUpdateList()
    }
    
    func tableViewSetup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UpdateTableViewCell.self, forCellReuseIdentifier: "updateCell")
    }
    
    func getViewModelData(){
        self.viewModel.getUpdateList()
        self.viewModel.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        self.viewModel.passNavTitle = { [weak self] in
            self!.navigationItem.title = self!.viewModel.titleNavbar
        }
        self.viewModel.errorOccured =  { [weak self] (error : String) in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.showAlertScreen(nil, message: error, alertTitle:"OK", responseHandler:nil)
                self?.refreshControl.endRefreshing()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkReachability()
        self.getViewModelData()
    }
    
    func  checkReachability() {
        guard  let r = reachability  else { return }
        if r.isReachable {
            view.backgroundColor = UIColor.green
        } else {
            view.backgroundColor = UIColor.red
        }
    }
    
    @objc func reachabilityDidChange(_ notification : Notification) {
        checkReachability()
    }
    
}

//table view datasource extention
extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView : UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.noOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell", for: indexPath) as? UpdateTableViewCell else {return UITableViewCell()}
        cell.rowItem = self.viewModel.updateAtIndex(index: indexPath.row)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
}
//table view delegate extention
extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = DetailTableViewController()
        detailController.selectedItem = self.viewModel.updateAtIndex(index: indexPath.row)
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

// Alert for error Handleing
extension UIViewController {
    typealias AlertActionHandler = ()-> Void
    
    func showAlertScreen(_ title: String?, message: String?, alertTitle : String?, responseHandler : AlertActionHandler?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction  = UIAlertAction(title: alertTitle, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            responseHandler?()
        })
        alert.addAction(okAction)
        present(alert, animated: true)
        
    }
}


