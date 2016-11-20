//
//  Book.swift
//  Consulta Persistente ISBN
//
//  Created by Walter Llano on 20/11/2016.
//  Copyright © 2016 Walter Llano. All rights reserved.
//

import Foundation
import UIKit

struct Book {

   var isbnCode : String!
   var title = "Sin Título"
   var authors = ["Sin Autores"]
   var cover = UIImage()

   init (isbnCode: String) {

      self.isbnCode = isbnCode
   }

   init (isbnCode: String, title: String, authors: [String], cover: UIImage) {

      self.isbnCode = isbnCode
      self.title = title
      self.authors = authors
      self.cover = cover
   }
}
