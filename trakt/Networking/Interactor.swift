//
//  Interactor.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import Foundation
import Alamofire

protocol TraktInteractor {

}

class TraktInteractorImpl: TraktInteractor {
    
    let client: TraktClient
    
    init() {
        self.client = TraktClient()
    }
    


}
