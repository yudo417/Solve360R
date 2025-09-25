

import SwiftUI

struct RecordView: View {
    @Binding var isRecordSheet: Bool
    var body: some View {

        ZStack{
            Colors.background

            VStack{
                ScrollView(showsIndicators: false){
                    ForEach(0..<10, id: \.self) { i in
                        RecordRow(recordRank: "\(i + 1)", recordScore: "\(i + 1)", recordDate: Date())
                            .padding(.vertical)
                    }
                }
            }

        }
    }
}

#Preview {
    RecordView(isRecordSheet: .constant(false))
}
