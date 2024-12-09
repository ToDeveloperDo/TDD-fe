//
//  Services.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import Foundation

protocol ServiceType {
    var todoService: TodoServiceType { get set }
    var authService: AuthenticationServiceType { get set }
    var githubService: GitHubSericeType { get set }
    var imageCacheService: ImageCacheServiceType { get set }
    var memberService: MemberServiceType { get set }
    var friendService: FriendServiceType { get set }
    var curriculumService: CurriculumServiceType { get set }
}

final class Services: ServiceType {
    var todoService: TodoServiceType
    var authService: AuthenticationServiceType
    var githubService: GitHubSericeType
    var imageCacheService: ImageCacheServiceType
    var memberService: MemberServiceType
    var friendService: FriendServiceType
    var curriculumService: CurriculumServiceType
    
    init() {
        self.todoService = TodoService()
        self.authService = AuthenticationService()
        self.githubService = GitHubService()
        self.imageCacheService = ImageCacheService(memoryStorage: MemoryStorage(), diskStorage: DiskStorage())
        self.memberService = MemberService()
        self.friendService = FriendService()
        self.curriculumService = CurriculumService()
    }
}


final class StubService: ServiceType {
    var todoService: TodoServiceType = StubTodoService()
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var githubService: GitHubSericeType = StubGitHubService()
    var imageCacheService: ImageCacheServiceType = StubImageCacheService()
    var memberService: MemberServiceType = StubMemberService()
    var friendService: FriendServiceType = StubFriendService()
    var curriculumService: CurriculumServiceType = StubCurriculumService()
}
