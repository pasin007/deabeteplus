//
//  ProfileDetailViewController.swift
//  deabeteplus
//
//  Created by pasin on 9/2/2563 BE.
//  Copyright © 2563 Ji Ra. All rights reserved.
//

import UIKit

class ProfileDetailViewController: UIViewController, BaseViewController {
    
    // MARK: - Cell Type
    enum ProfileCell: Int, CaseIterable {
        case profileImage = 0, profileInformation,
        //calText,
        calChart,
        //weightText,
        weightChart,
        //bmiText,
        bmiChart
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            configureTableView()
        }
    }
    
    // MARK: - Properties
    private var user: User!
    private var histories: [Double] = []
    private let viewModel: UserViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistories()
    }

    
    private func getHistories() {
        viewModel.getFoodHistories(user.id) { [weak self] (histories) in
            DispatchQueue.main.async {
                debugPrint("\(histories.count)")
                self?.histories = histories
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - Configuration
extension ProfileDetailViewController {
    func configure(_ user: User) {
        self.user = user
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        
        tableView.register(ProfileImageViewCell.nib, forCellReuseIdentifier: ProfileImageViewCell.identifier)
        tableView.register(ProfileInformationViewCell.nib, forCellReuseIdentifier: ProfileInformationViewCell.identifier)
//        tableView.register(CalLabelViewCell.nib, forCellReuseIdentifier: CalLabelViewCell.identifier)
        tableView.register(ChartViewCell.nib, forCellReuseIdentifier: ChartViewCell.identifier)
    }
    
}

// MARK: - UITableViewDataSource
extension ProfileDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileCell.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowCell = ProfileCell(rawValue: indexPath.row)!
        
        switch rowCell {
        case .profileImage:
             let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageViewCell.identifier, for: indexPath) as! ProfileImageViewCell
             let name = user.name
             cell.configure(name)
        case .profileInformation:
             let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInformationViewCell.identifier, for: indexPath) as! ProfileInformationViewCell
            return cell
//        case .calText:
//             let cell = tableView.dequeueReusableCell(withIdentifier: CalLabelViewCell.identifier, for: indexPath) as! CalLabelViewCell
//             cell.configure(.cal, value: "2000")
//            return cell
        case .calChart:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChartViewCell.identifier, for: indexPath) as! ChartViewCell
            if histories.count > 0 {
                cell.configure(histories, type: .cal, value: "\(histories[6])", action: {
                     print("seemoore cal")
                })
            }
           
            return cell
//        case .bmiText:
//            let cell = tableView.dequeueReusableCell(withIdentifier: CalLabelViewCell.identifier, for: indexPath) as! CalLabelViewCell
//            cell.configure(.bmi, value: "25")
//            return cell
        case .bmiChart:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChartViewCell.identifier, for: indexPath) as! ChartViewCell
            
//            if let user = UserManager.shared.currentUser {
                let bmis = user.bmis
                var cals: [Double] = []
                
                if user.bmis.count >= 4 {
                    cals = [
                        user.bmis[user.bmis.count - 4].bmi,
                        user.bmis[user.bmis.count - 2].bmi,
                        user.bmis[user.bmis.count - 3].bmi,
                        user.bmis[user.bmis.count - 1].bmi
                    ]
                    
                } else if user.bmis.count == 3 {
                    cals = [
                        user.bmis[user.bmis.count - 2].bmi,
                        user.bmis[user.bmis.count - 3].bmi,
                        user.bmis[user.bmis.count - 1].bmi
                    ]
                } else if user.bmis.count == 2 {
                    cals = [
                        user.bmis[user.bmis.count - 3].bmi,
                        user.bmis[user.bmis.count - 1].bmi
                    ]
                } else if user.bmis.count == 1 {
                    cals = [
                        user.bmis[user.bmis.count - 1].bmi
                    ]
                } else {
                     cals = [0]
                }
                
                let bmi = "\(bmis.last?.bmi ?? 0)"
                cell.configure(cals, type: .bmi, value: bmi)
//            }
            
            
            return cell
//        case .weightText:
//            let cell = tableView.dequeueReusableCell(withIdentifier: CalLabelViewCell.identifier, for: indexPath) as! CalLabelViewCell
//            cell.configure(.weight, value: "50.5")
//            return cell
        case .weightChart:
             let cell = tableView.dequeueReusableCell(withIdentifier: ChartViewCell.identifier, for: indexPath) as! ChartViewCell
             
//                if let user = UserManager.shared.currentUser {
                 let bmis = user.bmis
                 var cals: [Double] = []
                 
                 if user.bmis.count >= 4 {
                     cals = [
                         user.bmis[user.bmis.count - 4].weight,
                         user.bmis[user.bmis.count - 2].weight,
                         user.bmis[user.bmis.count - 3].weight,
                         user.bmis[user.bmis.count - 1].weight
                     ]
                     
                 } else if user.bmis.count == 3 {
                     cals = [
                         user.bmis[user.bmis.count - 2].weight,
                         user.bmis[user.bmis.count - 3].weight,
                         user.bmis[user.bmis.count - 1].weight
                     ]
                 } else if user.bmis.count == 2 {
                     cals = [
                         user.bmis[user.bmis.count - 3].weight,
                         user.bmis[user.bmis.count - 1].weight
                     ]
                 } else if user.bmis.count == 1 {
                     cals = [
                         user.bmis[user.bmis.count - 1].weight
                     ]
                 } else {
                    cals = [0]
                 }
                 
                 let weight = "\(bmis.last?.weight ?? 0)"
                 cell.configure(cals, type: .weight, value: weight)
//             }
            return cell
        }
       
        
       return UITableViewCell()
    }
    
    
}
