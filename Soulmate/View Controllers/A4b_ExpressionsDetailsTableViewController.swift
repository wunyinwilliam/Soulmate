//
//  A4b_ExpressionsDetailsTableViewController.swift
//  Soulmate
//
//  Created by Will Lam on 24/3/2021.
//

import UIKit

class A4b_ExpressionsDetailsTableViewController: UITableViewController {

    // MARK: - Variables
    var selectItems: [String] = []
    
    
    // MARK: - Actions
    @IBAction func pressed_add_button(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Enter New Option", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            switch self.title {
                case "Emotions":
                    self.updateSelectItems(emotionsList)
                    emotionsList.append(answer.text!)
                case "Reasons":
                    self.updateSelectItems(reasonsList)
                    reasonsList.append(answer.text!)
                default:
                    self.updateSelectItems(helpsList)
                    helpsList.append(answer.text!)
            }
            self.tableView.reloadData()
            self.selectPreviousItems()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self

        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: false)
        self.selectPreviousItems()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var noOfRows = 0
        switch self.title {
        case "Emotions":
            noOfRows = emotionsList.count
        case "Reasons":
            noOfRows = reasonsList.count
        default:
            noOfRows = helpsList.count
        }
        return noOfRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "A4bTableCell", for: indexPath)
        if let textLabel = cell.textLabel {
            switch self.title {
            case "Emotions":
                textLabel.text = emotionsList[indexPath.row]
            case "Reasons":
                textLabel.text = reasonsList[indexPath.row]
            default:
                textLabel.text = helpsList[indexPath.row]
            }
        } else {
            print("ERROR: There is no textLabel in the cell")
        }
        return cell
    }
    
    
    // MARK: - Private Functions
    
    private func selectPreviousItems() {
        for item in self.selectItems {
            switch self.title {
            case "Emotions":
                if let noOfRow = emotionsList.firstIndex(of: item) {
                    let indexpath = IndexPath(row: noOfRow, section: 0)
                    tableView.selectRow(at: indexpath, animated: false, scrollPosition: .top)
                }
            case "Reasons":
                if let noOfRow = reasonsList.firstIndex(of: item) {
                    let indexpath = IndexPath(row: noOfRow, section: 0)
                    tableView.selectRow(at: indexpath, animated: false, scrollPosition: .top)
                }
            default:
                if let noOfRow = helpsList.firstIndex(of: item) {
                    let indexpath = IndexPath(row: noOfRow, section: 0)
                    tableView.selectRow(at: indexpath, animated: false, scrollPosition: .top)
                }
            }
        }
    }
    
    private func updateSelectItems(_ list: [String]) {
        if tableView.indexPathsForSelectedRows != nil {
            var index: [Int] = []
            for indexPath in tableView.indexPathsForSelectedRows! {
                index.append(indexPath.row)
            }
            index.sort()
            for i in index {
                self.selectItems.append(list[i])
            }
        }
    }
}


// MARK: - Navigation

extension A4b_ExpressionsDetailsTableViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
                
        self.selectItems = []
        switch self.title {
        case "Emotions":
            self.updateSelectItems(emotionsList)
            (viewController as? A4_ExpressionsViewController)?.emotions = self.selectItems
        case "Reasons":
            self.updateSelectItems(reasonsList)
            (viewController as? A4_ExpressionsViewController)?.reasons = self.selectItems
        default:
            self.updateSelectItems(helpsList)
            (viewController as? A4_ExpressionsViewController)?.helps = self.selectItems
        }

    }
}
