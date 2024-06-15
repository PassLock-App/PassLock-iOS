//
//  SearchListExtensionController.swift
//  PasswordAutoFillExtension
//
//  Created by Melo on 2024/6/6.
//

import KakaFoundation
import AppGroupKit

class SearchListExtensionController: UISearchController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preSetupSubViews()
        self.preSetupHandleBuness()
    }
    
    private func preSetupSubViews() {
        self.view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    private func preSetupHandleBuness() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(_:)), name: UIApplication.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notify: Notification) {
        let rect = notify.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardH = rect?.height ?? 366
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardH, right: 0)
    }
    
    @objc func keyboardWillHidden(_ notify: Notification) {
        self.tableView.contentInset = UIEdgeInsets.zero
    }
    
    func searchWithKey(_ keyword: String) {
        let searchArray = self.originDataArray.filter { $0.searchMatcheItem(keyword) }
        self.searchArray = searchArray
        self.tableView.reloadData()
    }
    
    func cancelSearchAction() {
        self.searchArray.removeAll()
        self.tableView.reloadData()
    }
    
    // MARK:  GET && SET
    
    var onSelectCallBack: ((PrivateBaseItemModel)->Void)?
    
    var originDataArray: [PrivateBaseItemModel] = []
    
    lazy var searchArray: [PrivateBaseItemModel] = {
        return [PrivateBaseItemModel]()
    }()
    
    // MARK:  Lazy Init
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(PassbookTableExtensionCell.self, forCellReuseIdentifier: "PassbookTableExtensionCell")
        return view
    }()
    
}

extension SearchListExtensionController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = searchArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassbookTableExtensionCell", for: indexPath) as! PassbookTableExtensionCell
        cell.update(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = searchArray[indexPath.row]
        self.onSelectCallBack?(model)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let message = String(format: "Total %@ records found".localStr(), "\(searchArray.count)")
        return message
    }
    
}
