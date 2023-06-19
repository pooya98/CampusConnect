import SwiftUI

@MainActor
final class GroupViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published var meetUpGroups: [MeetUpGroup] = []
    
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func getMeetUpGroups() async throws{
        guard let currentUser = user else {
            print("Error. user not logged in")
            return
        }
        let groups = try await MeetUpManager.shared.getMeetUps(userId: currentUser.userId)
         
        print("Number of meet-up groups found: \(groups.count)")
        meetUpGroups = groups
    }

    
}

struct GroupView: View {
    @StateObject private var groupViewModel = GroupViewModel()
   
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("")
                        .font(.title)
                        .fontWeight(.bold)
                    //.padding(.bottom, 15)
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 246/255, green: 201/255, blue: 246/255))
                
                VStack(alignment: .leading) {
                    ScrollView {
                        ForEach(groupViewModel.meetUpGroups, id: \.groupId) { group in
                            
                            NavigationLink {
                                
                                GroupDetailsView(groupName: group.groupName)
                                
                            } label: {
                                MeetUpGlimpseView(groupName: group.groupName, profilePicUrl: group.groupProfileImageUrl, memberCount: "\(group.groupMembers?.count ?? 0)", meetingType: group.meetingType, meetingDay: group.meetingDay) {
                                    
                                    let dateFormatter = DateFormatter()
                                    
                                    if let date = group.meetingDate {
                                        if (group.meetingType == MeetingType.oneTime.rawValue) {
                                            
                                            dateFormatter.dateStyle = .long
                                            dateFormatter.timeStyle = .short
                                            
                                            return dateFormatter.string(from: date)
                                        }
                                        else if (group.meetingType == MeetingType.regular.rawValue) {
                                            dateFormatter.timeStyle = .short
                                            return dateFormatter.string(from: date)
                                        }
                                        
                                    }
                                    
                                    return ""
                                    
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CreateGroupView()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Meet-Up Groups")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .task {
            print("Loading currentuser data ...")
            try? await groupViewModel.loadCurrentUser()
            print("Loading complete!")
            
            print("Fetching meet-up groups...")
            try? await groupViewModel.getMeetUpGroups()
            print("fetching complete!")
        }
        
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
            GroupView()
    }
}
