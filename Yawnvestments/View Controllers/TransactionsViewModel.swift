//
//  TransactionsViewModel.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 07.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import Foundation

protocol TransactionsViewModelType: class {
    
}

class TransactionsViewModel: TransactionsViewModelType {
    
    private weak var view: TransactionsViewControllerType?
    
    init(view: TransactionsViewControllerType) {
        self.view = view
    }
}
