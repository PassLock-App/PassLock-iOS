//
//  FAQsViewController.swift
//  Kaka
//
//  Created by Kaka Inc. on 2022/9/20.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class FAQsViewController: SuperViewController {
    override func preSetupSubViews() {
        super.preSetupSubViews()
        self.title = "FAQs".localStr()
        
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = contentView.bounds
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
                
        let model1 = QuestionAnswerModel(questionStr: "1. How to enable Autofill password?".localStr(), realAnswerStr: "❀ Autofill password is an indie extension. You need to go to the system's [Settings] -> [Password] -> [Password Options] and select PassLock, and make sure the autofill switch enabled. Once activated, the next time you login, PassLock will help you autofill the account and password, so you don't need to remember the complex password at all.".localStr(), emptyAnswerStr: nil, isFold: false)
        let model2 = QuestionAnswerModel(questionStr: "2. Why some apps and websites don't support Autofill password?".localStr(), realAnswerStr: "❀ Autofill password is a passive extension, so whether it can be displayed on the keyboard depends on whether the developers of third-party apps or websites have set the input field types on the page to account and password types. If there is no autofill entry, you still need to open our app and copy-paste your account password.".localStr(), emptyAnswerStr: nil, isFold: true)
        let model3 = QuestionAnswerModel(questionStr: "3. What should I do if my iCloud don't have enough storage space?".localStr(), realAnswerStr: "❀ The price of the premium of iCloud is not expensive. It's $1 per month for 50GB. Consider it?".localStr(), emptyAnswerStr: nil, isFold: true)
        let model4 = QuestionAnswerModel(questionStr: "4. What is Passkeys? How it works?".localStr(), realAnswerStr: "❀ The emergence of Passkeys signifies the arrival of the passwordless era. Passkeys is a new generation identity verification technology that allows authentication without the need for account passwords. It relies solely on techniques such as biometric recognition to verify identities. And tech giants like Apple, Google, and Microsoft are making every effort to promote this technology.".localStr(), emptyAnswerStr: nil, isFold: true)
        let model5 = QuestionAnswerModel(questionStr: "5. Will Passkeys replace traditional password authentication methods?".localStr(), realAnswerStr: "❀ No. Just like how Apple led the way with fingerprint and Face ID authentication technologies, these new technologies have enhanced the security of traditional authentication methods. Passkeys can't completely replace traditional username and password logins, as that depends on the cooperation of the entire internet ecosystem. So we still need to use password managers to embrace the era of passwordless authentication.".localStr(), emptyAnswerStr: nil, isFold: true)
        
        self.dataItemArray.append(model1)
        self.dataItemArray.append(model2)
        self.dataItemArray.append(model3)
        self.dataItemArray.append(model4)
        self.dataItemArray.append(model5)
        
        self.tableView.reloadData()
    }
    
    //MARK: - 🌹 Lazy init 🌹
    
    lazy var dataItemArray: [QuestionAnswerModel] = {
        return [QuestionAnswerModel]()
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: contentView.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(UITableViewCell.self, forCellReuseIdentifier: "FAQsTableViewCell")
        return view
    }()
    
}

extension FAQsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataItemArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQsTableViewCell", for: indexPath)
        let model = self.dataItemArray[indexPath.section]
        
        var cellConfig = UIListContentConfiguration.subtitleCell()
        cellConfig.text = model.questionStr
        cellConfig.secondaryText = model.realAnswerStr
        cellConfig.textToSecondaryTextVerticalPadding = 12.ckValue()
        cellConfig.textProperties.font = UIFontBold(17.ckValue())
        cellConfig.secondaryTextProperties.font = UIFontLight(14.ckValue())
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cell.contentConfiguration = cellConfig
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var model = self.dataItemArray[indexPath.section]
        model.isFold.toggle()
        self.dataItemArray[indexPath.section] = model
        self.tableView.reloadData()
    }
    
}
