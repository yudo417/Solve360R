

import SwiftUI

struct RecordView: View {
    @Binding var isRecordSheet: Bool
    var body: some View {

        ZStack{
            Colors.background

        }
    }
}

#Preview {
    RecordView(isRecordSheet: .constant(false))
}
