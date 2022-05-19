//
//  WorldCompositionView.swift
//  CityXcape
//
//  Created by James Allan on 5/12/22.
//

import SwiftUI
import SwiftPieChart

struct WorldCompositionView: View {
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var username: String?

    @StateObject var vm: StreetPassViewModel
    
    var body: some View {
            
        VStack {
            HStack {
                VStack(spacing: 0) {
                    UserDotView(imageUrl: profileUrl ?? "", width: 70)
                 
                }
                .foregroundColor(.white)
                
                Text("\(username ?? "")'s World Makeup")
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                
                Spacer()
                
            }
            .padding()
            
            PieChartView(values: Array(vm.worldCompo
                                    .sorted(by: {$0.value > $1.value})
                                    .map({$0.value})
                                    .prefix(upTo:
                                                vm.worldCompo.count > 5 ? 5 :
                                                vm.worldCompo.count)),
                         names: Array(vm.worldCompo
                                    .sorted(by: {$0.value > $1.value})
                                    .map({$0.key.capitalized})
                                    .prefix(upTo: vm.worldCompo.count > 5 ? 5 :
                                                vm.worldCompo.count)),
                         formatter: {value in String(format: "%.2F", value)},
                         colors: vm.generateColors())
            
            
            
        }
        .background(Color.graph.edgesIgnoringSafeArea(.all))
    }
}

struct WorldCompositionView_Previews: PreviewProvider {
    static var previews: some View {
        WorldCompositionView(vm: StreetPassViewModel())
    }
}
