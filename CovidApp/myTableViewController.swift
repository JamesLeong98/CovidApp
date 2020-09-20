//
//  myTableViewController.swift
//  Homework3
//
//  Created by James Leong on 9/18/20.
//  Copyright © 2020 Carrie Hunner. All rights reserved.
//

import UIKit

class myTableViewController: UITableViewController {
    
    struct stateReport: Codable {
        let state:String?
        let positive:Int?
        let recovered:Int?
        let hospitalizedCurrently:Int?
        let lastUpdateEt:String?
        let death:Int?
        let positiveIncrease:Int?
    }
    
    var countryReport:[stateReport] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredStates:[stateReport] = []
    
    let stateDictionary: [String : String] = [
    "AK" : "Alaska",
    "AL" : "Alabama",
    "AR" : "Arkansas",
    "AS" : "American Samoa",
    "AZ" : "Arizona",
    "CA" : "California",
    "CO" : "Colorado",
    "CT" : "Connecticut",
    "DC" : "District of Columbia",
    "DE" : "Delaware",
    "FL" : "Florida",
    "GA" : "Georgia",
    "GU" : "Guam",
    "HI" : "Hawaii",
    "IA" : "Iowa",
    "ID" : "Idaho",
    "IL" : "Illinois",
    "IN" : "Indiana",
    "KS" : "Kansas",
    "KY" : "Kentucky",
    "LA" : "Louisiana",
    "MA" : "Massachusetts",
    "MD" : "Maryland",
    "ME" : "Maine",
    "MI" : "Michigan",
    "MN" : "Minnesota",
    "MP" : "Northern Mariana Islands",
    "MO" : "Missouri",
    "MS" : "Mississippi",
    "MT" : "Montana",
    "NC" : "North Carolina",
    "ND" : "North Dakota",
    "NE" : "Nebraska",
    "NH" : "New Hampshire",
    "NJ" : "New Jersey",
    "NM" : "New Mexico",
    "NV" : "Nevada",
    "NY" : "New York",
    "OH" : "Ohio",
    "OK" : "Oklahoma",
    "OR" : "Oregon",
    "PA" : "Pennsylvania",
    "PR" : "Puerto Rico",
    "RI" : "Rhode Island",
    "SC" : "South Carolina",
    "SD" : "South Dakota",
    "TN" : "Tennessee",
    "TX" : "Texas",
    "UT" : "Utah",
    "VA" : "Virginia",
    "VI" : "Virgin Islands",
    "VT" : "Vermont",
    "WA" : "Washington",
    "WI" : "Wisconsin",
    "WV" : "West Virginia",
    "WY" : "Wyoming"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllData()

        self.navigationItem.title = "COVID-19 Tracker"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search States"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source
    
    func getAllData() {
        
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        let url = URL(string: "https://covidtracking.com/api/states")!
        
        let task = mySession.dataTask(with: url) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                DispatchQueue.main.async {
                    // Network error
                    let alert = UIAlertController(title: "Network Error", message: "Please ensure you're connected to a network", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }

            // ensure there is data returned from this HTTP response
            guard let content = data else {
                DispatchQueue.main.async {
                    // Content Error
                    let alert = UIAlertController(title: "Content Error", message: "No data was fetched from API site", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                // decode the JSON into our array of stateReport's
                self.countryReport = try decoder.decode([stateReport].self, from: content)
                
                print("Got the data with total of \(self.countryReport.count) items")
                
                DispatchQueue.main.async {
                    // tell TableViewController to reload now I've populated the data
                    self.tableView.reloadData()
                }
                
            } catch {
                DispatchQueue.main.async {
                    // Decoding Error
                    let alert = UIAlertController(title: "Decoding Error", message: "There was an error in decoding the content", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    
        task.resume()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredStates.count
          }
        
        return self.countryReport.count
    }
    
    func parseNumber(num:Int) -> String {
        // Function to process number to desired format
        let fmt = NumberFormatter()
        fmt.maximumSignificantDigits = 3
        
        if num >= 1000000 {
           return fmt.string(for: Double(num)/1000000)! + "M"
        } else if num >= 1000 {
            return fmt.string(for: Double(num)/1000)! + "K"
        }
        
        return String(num)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! customTableViewCell
        
        let state: stateReport
          if isFiltering {
            state = filteredStates[indexPath.row]
          } else {
            state = countryReport[indexPath.row]
          }

        // Configure the cell...
        cell.state = state.state!
        cell.stateLabel.text = stateDictionary[state.state!]
        cell.stateFlag.image = UIImage(named: state.state!.lowercased())
        cell.stateCases.text = parseNumber(num: state.positive!)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! detailViewController
        let myRow = tableView!.indexPathForSelectedRow
        let selectedCell = tableView!.cellForRow(at: myRow!) as! customTableViewCell
        let currIndex = countryReport.firstIndex(where: { $0.state == selectedCell.state})
        
        destVC.propStateInitials = countryReport[currIndex!].state!
        destVC.propStateName = stateDictionary[countryReport[currIndex!].state!]!
        destVC.propTotalCases = parseNumber(num: countryReport[currIndex!].positive!)
        destVC.propDeaths = countryReport[currIndex!].death != nil ? parseNumber(num: countryReport[currIndex!].death!) : "No info"
        destVC.propDailyIncrease = countryReport[currIndex!].positiveIncrease != nil ? parseNumber(num: countryReport[currIndex!].positiveIncrease!) : "No info"
        destVC.propRecovered = countryReport[currIndex!].recovered != nil ? parseNumber(num: countryReport[currIndex!].recovered!) : "No info"
        destVC.propHospitalized = countryReport[currIndex!].hospitalizedCurrently != nil ? parseNumber(num: countryReport[currIndex!].hospitalizedCurrently!) : "No info"
        destVC.propLastUpdated = countryReport[currIndex!].lastUpdateEt!
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredStates = countryReport.filter { (state: stateReport) -> Bool in
            return stateDictionary[state.state!]!.lowercased().contains(searchText.lowercased())
          }
      
      tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            countryReport.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
         let movedReport = self.countryReport[sourceIndexPath.row]

         countryReport.remove(at: sourceIndexPath.row)
         countryReport.insert(movedReport, at: destinationIndexPath.row)
     }

}

extension myTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}
