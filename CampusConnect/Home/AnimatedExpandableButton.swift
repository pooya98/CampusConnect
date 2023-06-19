import SwiftUI

struct ExpandableButtonItem: Identifiable {
    let id = UUID()
    let image: String
    let label: String
    private(set) var action: (() -> Void)? = nil
}

struct AnimatedExpandableButton: View {
    @State var text = "none"
    @Binding var isExpanded : Bool
    @Binding var selected : String
    
    var body: some View {
        VStack {
            //your content here
            Spacer()
            HStack {
                Spacer()
                
                ExpandableButtonView(
                    primaryItem: ExpandableButtonItem(image: "plus", label:""),
                    secondaryItems: [
                        ExpandableButtonItem(image: "person.3.fill", label: "소모임 생성") {
                            withAnimation() {
                                selected = "group"
                            }
                        },
                        ExpandableButtonItem(image: "bolt.fill", label: "번개 생성") {
                            withAnimation() {
                                selected = "impromptu"
                            }
                        }] , isExpanded: $isExpanded, selected: $selected)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
    }
}

struct ExpandableButtonView: View {
    let primaryItem: ExpandableButtonItem
    let secondaryItems: [ExpandableButtonItem]
    let none: () -> Void = {}
    let size: CGFloat = 50
    let cornerRadius: CGFloat = 35
    @Binding var isExpanded : Bool
    @Binding var selected : String
    @State var showCreateGroup : Bool = false
    @State var showCreateImpromptu : Bool = false
    
    var body: some View {
        VStack {
            if isExpanded {
                HStack{
                    Image(systemName: secondaryItems[0].image)
                    Text(secondaryItems[0].label)
                }
                .foregroundColor(.white)
                .padding()
                .onTapGesture {
                    showCreateGroup = true
                }
                .fullScreenCover(isPresented: $showCreateGroup) {
                    CreateImpromtu(isShownFullScreenCover: $showCreateGroup, isExpanded: $isExpanded)
                }
                
                HStack{
                    Image(systemName: secondaryItems[1].image)
                    Text(secondaryItems[1].label)
                }
                .foregroundColor(.white)
                .padding()
                .onTapGesture {
                    showCreateImpromptu = true
                }
                .fullScreenCover(isPresented: $showCreateImpromptu) {
                    CreateImpromtu(isShownFullScreenCover: $showCreateImpromptu, isExpanded: $isExpanded)
                }
            }
            
            Button(action: {
                withAnimation {
                    self.isExpanded.toggle()
                }
                self.primaryItem.action?()
            }) {
                Image(systemName: primaryItem.image)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .rotationEffect(self.isExpanded ? .degrees(45) : .degrees(0))
            }
            .frame(width: size, height: size)
        }
        .background(Color(red: 247/255, green: 202/255, blue: 246/255))
        .cornerRadius(cornerRadius)
        .shadow(color: Color.black.opacity(0.17), radius: 3, x:2, y: 2)
    }
}


struct AnimatedExpandableButton_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedExpandableButton(isExpanded: .constant(false), selected: .constant("none"))
    }
}
