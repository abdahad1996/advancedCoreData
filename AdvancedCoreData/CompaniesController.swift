//
//  CompaniesController.swift
//  AdvancedCoreData
//
//  Created by prog on 5/31/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
struct company {
    let name:String
    let founded:Date
}

class CompaniesController: UITableViewController,createCompanyControllerDelegate {
    func createCompany(company: company) {
        companies.append(company)
        let indexPath = IndexPath(row: companies.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    var companies : [company] = [
        company(name: "Apple", founded: Date()),
        company(name: "Google", founded: Date()),
        company(name: "Facebook", founded: Date())
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = UIColor.darkBlue
        //        tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView() // blank UIView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "TEST ADD", style: .plain, target: self, action: #selector(addCompany))

    }
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navigationController = customNavigationController(rootViewController: createCompanyController)
        present(navigationController, animated: true, completion: nil)
    }
    @objc func addCompany() {
        print("handlecompany")
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
//        let company = companies[indexPath.row]
        cell.backgroundColor = .tealColor

        let company = companies[indexPath.row]
        print(company.name)
//
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return companies.count
//        return 8
    }

}
