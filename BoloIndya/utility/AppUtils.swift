//
//  AppUtils.swift
//  BoloIndya
//
//  Created by Mushareb on 09/09/20.
//  Copyright © 2020 Synergybyte Media Private Limited. All rights reserved.
//

import Foundation
import SVProgressHUD
class AppUtils {

static func showPrograssBar(show:Bool!)
{
    if show == true {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(.white)

    }else{
        SVProgressHUD.dismiss()
    }

}

}
