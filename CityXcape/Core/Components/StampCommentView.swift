//
//  StampCommentView.swift
//  CityXcape
//
//  Created by James Allan on 11/19/22.
//

import SwiftUI

struct StampCommentView: View {
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?

    var stamp: Verification
    @State var comments: [Comment]
    @State private var submissionText: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    var body: some View {
        VStack {
            
            HStack {
                Image("Stamp")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("Comment on \(stamp.name)")
                    .alert(isPresented: $showAlert) {
                        return Alert(title: Text(alertMessage))
                    }
                Spacer()
            }
            .padding(.horizontal, 20)
            
            
            Divider()
                .frame(height: 0.5)
                .background(Color.white)
        
            ScrollView {
                
                ForEach(comments) { comment in
                    MessageView(comment: comment)
                        
                }
            }
            
            
            HStack {
                UserDotView(imageUrl: profileUrl ?? "", width: 30)
                   
                TextField("Add comment", text: $submissionText)
                    .placeholder(when: submissionText.isEmpty) {
                        Text("Add comment").foregroundColor(.gray)
                }
                .padding()
                
                
                Button {
                    //TBD
                    postComment()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                }

            }
            .padding(.horizontal, 10)

        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .onAppear {
           loadComments()
        }
        
    }
    
    fileprivate func postComment() {
        let user = User()
        DataService.instance.postStampComment(spotId: stamp.id, content: submissionText, verifierId: stamp.verifierId, user: user) { result in
            switch result {
            case .success(let commentId):
                guard let id = commentId else {return}
                let comment = Comment(id: id, user: user, comment: submissionText)
                comments.append(comment)
                submissionText = ""
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

       
    }
    
    fileprivate func loadComments() {
        DataService.instance.downloadStampComments(forId: stamp.verifierId, verificationId: stamp.id) {  result in
            switch result {
            case .success(let comments):
                if comments.isEmpty {
                    self.alertMessage = "No comments on this stamp"
                    self.showAlert.toggle()
                    return
                }
                self.comments = comments
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.showAlert.toggle()
            }
        }
    }
}

struct StampCommentView_Previews: PreviewProvider {
    static var previews: some View {
        StampCommentView(stamp: Verification.demo, comments: [])
    }
}
