//
//  HealthDataRow.swift
//  iHealth
//
//  Created by Rohit Nisal on 5/13/21.
//

import SwiftUI

struct HealthDataRow: View {
    var stat: statsObject
    var body: some View {
        HStack {
            Text(stat.name)
            Spacer()
            Text(stat.strValue)
        }
    }
}

struct HealthDataRow_Previews: PreviewProvider {
    static var previews: some View {
        HealthDataRow(stat: statsObject(name: "Steps"))
    }
}
