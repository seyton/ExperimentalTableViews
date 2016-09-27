//
//  ViewController.swift
//  ExperimentalViews
//
//  Created by Wesley Matlock on 9/26/16.
//  Copyright © 2016 net.insoc. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    var stateData = [State]() {
        didSet {
            for _ in 0..<stateData.count {
                booleanArray.append(NSNumber(value: false))
            }
        }
    }
    
    var selectedHeaderIndexPath: IndexPath?
    var selectedIndexPath: IndexPath?
    var booleanArray = [NSNumber]()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {

            tableView.register(UINib(nibName: String(describing: CityTableViewCell.self), bundle: nil),
                               forCellReuseIdentifier: String(describing: CityTableViewCell.self))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        stateData = Utility.loadJsonData("CityData", withExtension: "json")
        
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            //MARK: - TODO Add delegate
            registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: view)
        }
        else {
            let alertController = UIAlertController(title: "3D Touch Unavailable", message: "Get an updated device", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (actionType) in
                print("Not available")
            })
            alertController.addAction(action)
            present(alertController, animated: true, completion: { 
                //Nothing to see here
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CellSelectedSegue" && selectedIndexPath != nil {
            
            let destinationVC = segue.destination as! CityMapViewController
            let city = stateData[selectedHeaderIndexPath!.section].cities[selectedIndexPath!.row]
            
            destinationVC.currentCity = city
        }
    }
}

//MARK: - GestureRecognizer
extension CityViewController {
    
    func headerViewTapped(_ gesture: UITapGestureRecognizer) {
        
        selectedHeaderIndexPath = IndexPath(row: 0, section: (gesture.view?.tag)!)
        
        let isCollapsed = !booleanArray[(selectedHeaderIndexPath?.section)!].boolValue
        
        for (index, _) in booleanArray.enumerated() {
            if index == selectedHeaderIndexPath?.section {
                booleanArray[index] = NSNumber(value: isCollapsed)
                break
            }
        }
        
        let range = NSMakeRange((selectedHeaderIndexPath?.section)!, 1)
        let sectionToReload = IndexSet(integersIn: range.toRange() ?? 0..<0)
        
        tableView.reloadSections(sectionToReload, with: .fade)
        
        if gesture.view?.tag == stateData.count - 1 {
            tableView.scrollToRow(at: selectedHeaderIndexPath!, at: .bottom, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource
extension CityViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return stateData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateData[section].cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !booleanArray[indexPath.section].boolValue {
            return UITableViewCell()
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CityTableViewCell.self), for: indexPath) as! CityTableViewCell
            cell.currentCity = stateData[indexPath.section].cities[indexPath.row]
            return cell
        }
    }
}

extension CityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        headerView.backgroundColor = .white
        headerView.tag = section
        
        let nameLabel = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width-70, height: 50))
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = .blue
        nameLabel.font = UIFont(name: "Helvetica Neue-Light", size: 17.0)
        nameLabel.text = stateData[section].name
        
        headerView.addSubview(nameLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CityViewController.headerViewTapped(_:)))
        headerView.addGestureRecognizer(tapGesture)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if booleanArray[indexPath.section].boolValue {
            return 250.0
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "CellSelectedSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.isKind(of: CityTableViewCell.self) {
           setCellImageOffset(cell as! CityTableViewCell, indexPath: indexPath)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == tableView {
            if let indexArray = tableView.indexPathsForVisibleRows {
                
                for indexPath in indexArray {
                    if let cell = tableView.cellForRow(at: indexPath) {
                        if cell.isKind(of: CityTableViewCell.self) {
                            setCellImageOffset(cell as! CityTableViewCell, indexPath: indexPath)
                        }
                    }
                }
            }
        }
    }

    private func setCellImageOffset(_ cell: CityTableViewCell, indexPath: IndexPath) {
        
        let cellFrame = tableView.rectForRow(at: indexPath)
        let cellFrameInTable = tableView.convert(cellFrame, to: tableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = tableView.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        cell.setBackGroundOffset(cellOffsetFactor)
    }
}

extension CityViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    
        let cellLocation = tableView.convert(location, from: view)
        
        guard  let indexPath = tableView.indexPathForRow(at: cellLocation), let cell = tableView.cellForRow(at: indexPath) as? CityTableViewCell else {
            return nil
        }
        
        guard let previewViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: CityMapViewController.self)) as? CityMapViewController else {
            return nil
        }
        
        guard let headerIndexPath = selectedHeaderIndexPath else {
            return nil
        }
        
        let city = stateData[headerIndexPath.section].cities[indexPath.row]
        previewViewController.currentCity = city
        previewViewController.preferredContentSize = CGSize(width: 0, height: 0)
        
        previewingContext.sourceRect = view.convert(cell.frame, from: tableView)

        return previewViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
    }
}
