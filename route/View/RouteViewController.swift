//
//  RouteViewController.swift
//  route
//
//  Created by Abilio Gambim Parada on 17/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import UIKit

class RouteViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finderView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: RouteViewModel?

    private lazy var fromSuggestions: [String] = []
    private lazy var allSuggestions: [String] = []
    
    private lazy var tripList = [Trip]()


    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupMVVM()
    }

    @IBAction func pressGoButton(){
        if let from = fromTextField.text, let destination = toTextField.text{
            viewModel?.findRoute(from: from, destination: destination)
        }
    }
    
}

extension RouteViewController{
    func setupView() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        fromTextField.delegate = self
        toTextField.delegate = self
        fromTextField.autocorrectionType = .no
        toTextField.autocorrectionType = .no

        // TODO: Insert on localizable
        fromTextField.placeholder = "Origem"
        toTextField.placeholder = "Destino"

        tableView.dataSource = self

    }

    func setupMVVM() {
        viewModel = RouteViewModel()
        setupBinding()
        viewModel?.setupController()
    }

    func setupBinding() {
        viewModel?.onLoading = { [weak self] (loading) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if loading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }

        viewModel?.onServiceError = { [weak self] (serverError) in
            guard let self = self else { return }
            debugPrint(serverError)
        }

        viewModel?.onAllNodes = { [weak self] (allNodes) in
            guard let self = self else { return }
            allNodes.forEach { (node) in
                self.allSuggestions.append(node.description)
            }
            debugPrint(allNodes.count)
        }

        viewModel?.onFromNodes = { [weak self] (fromNodes) in
            guard let self = self else { return }
            fromNodes.forEach { (node) in
                self.fromSuggestions.append(node.description)
            }
            debugPrint(fromNodes.count)
        }
        
        viewModel?.onGetRoute = { [weak self] (route) in
            guard let self = self else { return }
            route.forEach { (trip) in
                debugPrint(trip.description)
            }
            self.tripList.removeAll()
            self.tripList.append(contentsOf: route)
            self.tableView.reloadData()
        }
    }
}

extension RouteViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        return !autoCompleteText(in: textField, using: string, suggestions: allSuggestions)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func autoCompleteText(in textField: UITextField, using string: String, suggestions: [String]) -> Bool {
        if !string.isEmpty,
            let selectedTextRange = textField.selectedTextRange,
            selectedTextRange.end == textField.endOfDocument,
            let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
            let text = textField.text(in: prefixRange) {

            let prefix = text + string
            let matches = suggestions.filter {
                $0.hasPrefix(prefix)
            }
            if matches.count > 0 {
                textField.text = matches[0]
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    return true
                }
            }
        }
        return false
    }
}

extension RouteViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "TRIP_CELL") as? TripViewCell {

            cell.setupView(trip: tripList[indexPath.row])
            return cell
        }

        return UITableViewCell()
    }

}
