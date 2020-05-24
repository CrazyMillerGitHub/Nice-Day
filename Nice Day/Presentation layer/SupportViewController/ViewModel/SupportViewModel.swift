//
//  SupportViewModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//
import UIKit
enum SupportViewModelItemType {
    case email
    case fiveDigitKey
    case newPassword
    case newPasswordAgain
}

protocol SupportViewModelItem {
    var type: SupportViewModelItemType { get }
}

class SupportEmailModelItem: SupportViewModelItem {
    
    var item: String {
        return "_enterYourEmail".localized()
    }
    
    var type: SupportViewModelItemType {
        return .email
    }
}

class FiveDigitKeyModelItem: SupportViewModelItem {
    
    var item: String {
        return "_enterFiveDigitPassword".localized()
    }
    
    var type: SupportViewModelItemType {
        return .fiveDigitKey
    }
}

class NewPasswordCellModelItem: SupportViewModelItem {
    
    var item: String {
        return "_enterNewPassword".localized()
    }
    
    var type: SupportViewModelItemType {
        return .newPassword
    }
}

class NewPassworAgainModelItem: SupportViewModelItem {
    
    var item: String {
        return "_enterNewPasswordAgain".localized()
    }
    
    var type: SupportViewModelItemType {
        return .newPasswordAgain
    }
}

class SupportViewModel: NSObject {
    var items = [SupportViewModelItem]()
    
    override init() {
        super.init()
        
//        let email = SupportEmailModelItem()
//        items.append(email)
//
//        let fiveDigit = FiveDigitKeyModelItem()
//        items.append(fiveDigit)
//
//        let newPassword = NewPasswordCellModelItem()
//        items.append(newPassword)
//
//        let passwordAgain = NewPassworAgainModelItem()
//        items.append(passwordAgain)
        
    }
}
extension SupportViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        switch item.type {
        case .email:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmailSupportCell.identifier, for: indexPath) as? EmailSupportCell else {
                return UITableViewCell()
            }
            cell.stageLabel.text = String(indexPath.section + 1)
            cell.item = item
            return cell
        case .fiveDigitKey:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FiveDigitCell.identifier, for: indexPath) as? FiveDigitCell else {
                return UITableViewCell()
            }
            cell.stageLabel.text = String(indexPath.section + 1)
            cell.item = item
            return cell
        case .newPassword:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPasswordCell.identifier, for: indexPath) as? NewPasswordCell else {
                return UITableViewCell()
            }
            cell.stageLabel.text = String(indexPath.section + 1)
            cell.item = item
            return cell
        case .newPasswordAgain:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPasswordAgain.identifier, for: indexPath) as? NewPasswordAgain else {
                return UITableViewCell()
            }
            cell.stageLabel.text = String(indexPath.section + 1)
            cell.item = item
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
    
    }
}
