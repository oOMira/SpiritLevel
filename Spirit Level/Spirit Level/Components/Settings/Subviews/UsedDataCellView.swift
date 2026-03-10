import SwiftUI

struct UsedResourcesView: View {
    var body: some View {
        List {
            
            VStack {
                Text("Estorgen Ester Data")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(.init("Estradiol pharmacokinetic data sourced from [\"Idealized curves of estradiol levels after injection of different estradiol esters in women\"](https://en.wikipedia.org/wiki/File:Idealized_curves_of_estradiol_levels_after_injection_of_different_estradiol_esters_in_women.png) via Wikimedia Commons, licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)."))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle("Used Resources")
    }
}
