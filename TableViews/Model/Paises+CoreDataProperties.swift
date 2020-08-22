//
//  Paises+CoreDataProperties.swift
//  TableViews
//
//  Created by Juan Bonforti on 22/08/2020.
//  Copyright © 2020 MoureDev. All rights reserved.
//
//

import Foundation
import CoreData


extension Paises {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paises> {
        return NSFetchRequest<Paises>(entityName: "Paises")
    }

    @NSManaged public var nombre: String?

}
