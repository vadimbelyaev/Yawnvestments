//
//  PortfolioViewController.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 16.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import UIKit

protocol PortfolioViewControllerType: class {

}

class PortfolioViewController: UITableViewController, PortfolioViewControllerType {

    var model: PortfolioViewModelType!

    /// Intentional tight coupling for the lack of a coordinator.
    private struct ViewModelFactory {
        static func getViewModel(view: PortfolioViewControllerType) -> PortfolioViewModelType {
            return PortfolioViewModel(view: view, assetService: AssetService.shared)
        }
    }

    private enum Constants {
        static let portfolioCellNibName = String(describing: PortfolioCell.self)
        static let portfolioCellReuseIndentifier = Self.portfolioCellNibName
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if model == nil {
            model = ViewModelFactory.getViewModel(view: self)
        }

        tableView.register(UINib(nibName: Constants.portfolioCellNibName, bundle: nil), forCellReuseIdentifier: Constants.portfolioCellReuseIndentifier)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.portfolioCellReuseIndentifier, for: indexPath) as? PortfolioCell else {
            return UITableViewCell()
        }

        if let cellViewModel = model.cellViewModel(at: indexPath) {
            cell.model = cellViewModel
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
