//
//  PhotoListViewModelTests.swift
//  PhotoListViewModelTests
//
//  Created by Hemg on 2/10/24.
//

import XCTest
@testable import ios_unsplash
import Combine

class MockUnsplashRepository: UnsplashRepository {
    var fetchPhotosResult: Result<[Photo], Error>?
    
    func fetchPhotos(page: Int) -> AnyPublisher<[Photo], Error> {
        return fetchPhotosResult!.publisher.eraseToAnyPublisher()
    }
}

final class PhotoListViewModelTests: XCTestCase {
    
    var viewModel: PhotoListViewModel!
    var mockRepository: MockUnsplashRepository!
    
    override func setUpWithError() throws {
        mockRepository = MockUnsplashRepository()
        viewModel = PhotoListViewModel(repository: mockRepository)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockRepository = nil
    }
    
    func test_통신실패시에배열이_비어있는지_확인() {
        // Given
        let expectedError = NSError(domain: "test", code: 0, userInfo: nil)
        mockRepository.fetchPhotosResult = .failure(expectedError)
        
        // When
        viewModel.loadPhotos(isRefresh: true)
        
        // Then
        XCTAssertTrue(viewModel.photos.isEmpty)
    }
    
    func test_로딩중확인하기() {
        // Given
        mockRepository.fetchPhotosResult = .success([])
        
        // When
        viewModel.loadPhotos(isRefresh: false)
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.isLoading, true)
    }
}
