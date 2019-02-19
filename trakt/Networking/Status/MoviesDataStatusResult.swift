//
//  MoviesDataStatusResult.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/19/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation

enum MoviesDataStateResult {
    case Success, Failed, Error
}

class TaskResult {
    var result: MoviesDataStateResult
    
    init(result: MoviesDataStateResult) {
        self.result = result
    }
}
