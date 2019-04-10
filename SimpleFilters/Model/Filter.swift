//  Filter.swift
//  SimpleFilters

//  Created by George Garcia on 4/10/19.
//  Copyright © 2019 George Garcia. All rights reserved.

import Foundation

struct Filter {
    
    var filterName:             String
    var filterEffectValue:      Any?
    var filterEffectValueName:  String?
    
    init(filterName: String, filterEffectValue: Any?, filterEffectValueName: String?) {
        self.filterName             = filterName
        self.filterEffectValue      = filterEffectValue
        self.filterEffectValueName  = filterEffectValueName
    }
    
}
