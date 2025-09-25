

import SwiftUI

struct RecordView: View {
    @Binding var isRecordSheet: Bool
    var body: some View {

        ZStack{
            Colors.background

            VStack{
                ScrollView(showsIndicators: false){
                    ForEach(0..<10, id: \.self) { _ in
                        RecordRow()
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
