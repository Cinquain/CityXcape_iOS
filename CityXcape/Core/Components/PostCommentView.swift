//
//  PostCommentView.swift
//  CityXcape
//
//  Created by James Allan on 7/1/22.
//

import SwiftUI

struct PostCommentView: View {
    
    @State var comments: [Comment]
    let verifier: User
    let verification: Verification
    @State private var submissionText: String = ""
    
    var body: some View {
                VStack {
                    
                    VStack() {
                        HStack {
                            UserDotView(imageUrl: verifier.profileImageUrl, width: 40)
                            Text("Comment on \(verifier.displayName)'s Stamp")
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        
                        Divider()
                            .frame(height: 0.5)
                            .background(Color.white)
                    
                    ScrollView {
                        
                        ForEach(comments) { comment in
                            MessageView(comment: comment)
                        }
                    }
                    
                    HStack {
                        UserDotView(imageUrl: "", width: 30)
                           
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
            }
        //End of body
    }
    
    fileprivate func postComment() {
        let user = User()
        DataService.instance.postStampComment(spotId: verification.id, content: submissionText, verifierId: verification.verifierId, user: user) { result in
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
    
}

struct PostCommentView_Previews: PreviewProvider {
    static var previews: some View {
        PostCommentView(comments: [], verifier: User(), verification: Verification.demo)
    }
}
