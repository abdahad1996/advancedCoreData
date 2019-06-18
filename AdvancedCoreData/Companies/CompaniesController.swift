//
//  CompaniesController.swift
//  AdvancedCoreData
//
//  Created by prog on 5/31/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import CoreData



class CompaniesController: UITableViewController,createCompanyControllerDelegate {
    func didEditCompany(company: Company) {
        print("edit")
    }
    
    //company object coming from delegation
    func createCompany(company: Company) {
        companies.append(company)
        let indexPath = IndexPath(row: companies.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
// compamy coming from core data
    var companies = [Company]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCompanies()

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
    func fetchCompanies(){
        //fetching from coredata
        
        //temporary area
        let context = CoreDataManager.shared.container.viewContext
        
        // fetch requests which will give array of companu
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do{
           let companies =  try context.fetch(fetchRequest)
            companies.forEach { (Company) in
                print("the company is \(Company.name) ")
            }
            self.companies = companies
            tableView.reloadData()

        }
        catch let err{
            print("Failed to fetch companies:", err)

        }
        
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

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (_, IndexPath) in
            let company = self.companies[indexPath.row]
            print("delete \(company)")
            
            //remove from array
            self.companies.remove(at: indexPath.row)
            //remove row from tableview
            self.tableView.deleteRows(at: [IndexPath], with: .automatic)
            
            //remove from coredata
            let context = CoreDataManager.shared.container.viewContext
            context.delete(company)
            do{
               try context.save()
            }
            catch let err{
                print("Failed to delete company:", err)

            }
        }
        deleteAction.backgroundColor = UIColor.lightRed
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandler)
        editAction.backgroundColor = UIColor.darkBlue
        
        return [deleteAction, editAction]
    }
    func editHandler(action:UITableViewRowAction,indexpath:IndexPath){
        print("Editing company in separate function")
        let editCompany = CreateCompanyController()
        editCompany.company = companies[indexpath.row]
        
        editCompany.delegate = self
        
        let navController = customNavigationController(rootViewController: editCompany)
        present(navController, animated: true, completion: nil)
        

        
    }
    
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
        cell.backgroundColor = .tealColor

        let company = companies[indexPath.row]

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
