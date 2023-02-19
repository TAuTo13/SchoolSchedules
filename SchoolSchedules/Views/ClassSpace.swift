//
//  ClassSpace.swift
//  SchoolSchedules
//
//  Created by 多田桃大 on 2023/02/11.
//

import SwiftUI

struct ClassSpace: View {
    var classCard: ClassCard? = nil
    
    init(){}
    
    init(classCard: ClassCard){
        self.classCard = classCard
    }
    
    var body: some View {
        if(classCard != nil){
            classCard
        }
    }
}

//struct ClassSpace_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassSpace(classCard: ClassCard())
//    }
//}
