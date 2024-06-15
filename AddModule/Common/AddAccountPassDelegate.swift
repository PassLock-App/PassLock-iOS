//
//  AddAccountPassCellDelegate.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/5/7.
//

import KakaUIKit


protocol AddAccountPassDelegate: AnyObject {
    
    func editCustomTitleWithCell(cell: AddCustomTitleTableCell, customTitle: String?)
    
    func editUsernameWithCell(cell: AddUserNameTableCell, userName: String?)
    
    func editPasswordWithCell(cell: AddPasswordTableCell, password: String?)
    
    func editNotesWithCell(cell: AddNotesTableCell, notes: String?)
    
}
