//
//  TravelsTableViewController.swift
//  MyTravels
//
//  Created by Maurício Oliveira on 13/02/2019.
//  Copyright © 2019 Maurício Oliveira. All rights reserved.
//

import UIKit

class TravelsTableViewController: UITableViewController {
    
    var travels: [Dictionary<String,String> ] = []
    var navigationControl = "add"

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationControl="add"
        reloadData()
    }
    
    func reloadData() {
        travels = SaveData().listTravels()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "travelReuse", for: indexPath)
        
        cell.textLabel?.text = travels[indexPath.row]["local"]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SaveData().removeTravel(index: indexPath.row)
            reloadData()
        }
    }
    
    //row selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationControl = "list"
        performSegue(withIdentifier: "localSegue", sender: indexPath.row)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "localSegue" {
            
            let vcDestiny = segue.destination as! MapViewController
            
            if self.navigationControl == "list" {
                if let index = sender {
                    
                    let idx = index as! Int
                    
                    vcDestiny.travel = travels[idx]
                    vcDestiny.selectedIndex = idx
                }
            } else {
                vcDestiny.travel = [:]
                vcDestiny.selectedIndex = -1
            }
            
        }
    }

}
