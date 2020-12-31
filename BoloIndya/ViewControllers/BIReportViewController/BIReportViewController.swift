//
//  BIReportViewController.swift
//  BoloIndya
//
//  Created by Rahul Garg on 29/12/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import UIKit
import Alamofire

protocol BIReportViewControllerDelegate: class {
    func didTapDismissButton()
    func didTapSubmit(text: String, object: BIReportResult, video: Topic?)
}

final class BIReportViewController: UIViewController {
    @IBOutlet private weak var mainContentView: UIView! {
        didSet {
            mainContentView.layer.borderWidth = 1
            mainContentView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            mainContentView.layer.cornerRadius = 7
            mainContentView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var reportLabel: UILabel!
    @IBOutlet private weak var optionTableView: UITableView! {
        didSet {
            optionTableView.register(cellType: BIReportTableCell.self)
            optionTableView.delegate = self
            optionTableView.dataSource = self
        }
    }
    @IBOutlet private weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
            textView.layer.cornerRadius = 5
            textView.clipsToBounds = true
            
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            
            textView.delegate = self
        }
    }
    @IBOutlet private weak var cancelButton: UIButton! {
        didSet {
            cancelButton.layer.cornerRadius = 5
            cancelButton.clipsToBounds = true
        }
    }
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 5
            submitButton.clipsToBounds = true
        }
    }
    
    weak var delegate: BIReportViewControllerDelegate?
    var model: BIReportModel?
    var video: Topic?
    
    private var placeholder = "Please type here..."
    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionTableView.reloadData()

        let count = model?.results.count ?? 0
        let height = CGFloat(count * 30)
        if height > 200 {
            tableHeightConstraint.constant = 200
            optionTableView.isScrollEnabled = true
        } else {
            tableHeightConstraint.constant = height
            optionTableView.isScrollEnabled = false
        }
    }
    
    func config(model: BIReportModel) {
        self.model = model
    }
    
    @IBAction private func didTapCacel(_ sender: UIButton) {
        delegate?.didTapDismissButton()
    }
    
    @IBAction private func didTapSubmit(_ sender: UIButton) {
        guard let text = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty,
              text != placeholder,
              let result = model?.results,
              result.count > selectedIndex
            else { return }
        
        delegate?.didTapSubmit(text: text, object: result[selectedIndex], video: video)
    }
}

extension BIReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: BIReportTableCell.self, for: indexPath)
        cell.selectedButton.isSelected = selectedIndex == indexPath.row
        if let result = model?.results, result.count > indexPath.row {
            cell.model = result[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}

extension BIReportViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
}
