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
    @IBOutlet weak var statusDescription: UILabel!

    private var viewModel: RouteViewModel?

    private lazy var fromSuggestions: [String] = []
    private lazy var allSuggestions: [String] = []

    private lazy var tripSteps = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardObserver()
        setupView()
        setupMVVM()
    }

    @IBAction func pressGoButton() {
        if let from = fromTextField.text, let destination = toTextField.text {
            viewModel?.findRoute(from: from, destination: destination)
        }
    }

}

extension RouteViewController {

    func setupView() {
        setupTextField(textField: fromTextField,
                       tag: ViewValues.Tag.textFieldFrom,
                       placeholderKey: Keys.RouteViewController.placeholderFrom)

        setupTextField(textField: toTextField,
                       tag: ViewValues.Tag.textFieldTo,
                       placeholderKey: Keys.RouteViewController.placeholderTo)

        setupTableView()

        statusDescription.isHidden = true
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
            self.statusDescription.isHidden = false
            self.statusDescription.text = serverError.localizedDescription
            self.tableView.isHidden = true
        }

        viewModel?.onEngineError = { [weak self] (engineError) in
            guard let self = self else { return }
            self.statusDescription.isHidden = false
            self.statusDescription.text = engineError.localizedDescription
            self.tableView.isHidden = true
        }

        viewModel?.onAllNodes = { [weak self] (allNodes) in
            guard let self = self else { return }
            self.allSuggestions.append(contentsOf: allNodes)
        }

        viewModel?.onFromNodes = { [weak self] (fromNodes) in
            guard let self = self else { return }
            self.fromSuggestions.append(contentsOf: fromNodes)
        }

        viewModel?.onTripReady = { [weak self] (tripSteps) in
            guard let self = self else { return }

            self.tripSteps = tripSteps
            self.tableView.isHidden = false
            self.statusDescription.isHidden = true
            self.tableView.reloadData()
        }
    }
}

extension RouteViewController: UITextFieldDelegate {

    private func setupTextField(textField: UITextField, tag: Int, placeholderKey: String) {
        textField.tag = tag
        textField.autocorrectionType = .no
        textField.placeholder = NSLocalizedString(placeholderKey, comment: placeholderKey)
        textField.delegate = self
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if textField.tag == ViewValues.Tag.textFieldFrom {
            return !autoCompleteText(in: textField, using: string, suggestions: fromSuggestions)
        } else {
            return !autoCompleteText(in: textField, using: string, suggestions: allSuggestions)
        }
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

    private func setupTableView() {
        let nib = UINib(nibName: ViewValues.TripViewCell.nibName, bundle: nil)

        tableView.register(nib, forCellReuseIdentifier: ViewValues.TripViewCell.cellIdentifier)
        tableView.rowHeight = ViewValues.Table.heightForRowTrip

        tableView.isHidden = true
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripSteps
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewValues.Table.heightForRowTrip
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cellViewModel = viewModel?.rowViewModel(for: indexPath.row),
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewValues.TripViewCell.cellIdentifier) as? TripViewCell {

            cell.setupView(viewModel: cellViewModel)
            cellViewModel.setupViewCell()

            return cell
        } else {
            return UITableViewCell()
        }
    }

}
