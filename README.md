# Unsplash

## 📖 목차
1. [소개](#-소개)
2. [팀원](#-팀원)
3. [실행 화면](#-실행-화면)
4. [트러블 슈팅](#-트러블-슈팅)
5. [핵심 경험](#-핵심-경험)

</br>

## 🍀 소개
- 주제에 맞는 사진을 볼수 있으며, 검색을 통하여 원하는 분류의 사진을 볼 수 있습니다.
- [`Unsplash API`](https://unsplash.com/documentation#search-photos)를 통하여 사진을 업로드 합니다
</br>

## 👨‍💻 팀원
| hamg |
| :--------: |
|<Img src="https://github.com/hemg2/ios-unsplash/assets/101572902/4b39d5c3-1313-4b83-950c-66fecfbadfcb" width="250" height="400">|
|[Github Profile](https://github.com/Hoon94) |

</br>

## 💻 실행 화면

|    |메인 화면| 테마 선택 화면|
|:--:|:--:|:--:|
|작동 화면| <img src="https://github.com/hemg2/ios-unsplash/assets/101572902/4aafad9e-4788-46f9-a127-c076422d647e" width="400" height="600"/>|<img src="https://github.com/hemg2/ios-unsplash/assets/101572902/422b5e0b-a2a6-44e3-bf31-4a963f703b64" width="400" height="600"/>|

|    | 디테일 뷰| 디테일 뷰 이동 |
|:--:|:--:|:--:|
|작동 화면| <img src="https://github.com/hemg2/ios-unsplash/assets/101572902/246d04d5-c016-49f4-967f-01af154a19bd" width="400" height="600"/>|<img src="https://github.com/hemg2/ios-unsplash/assets/101572902/223c6e1e-74ee-437f-8ce1-f29b951438d9" width="400" height="600"/>|

|    |카테고리 화면 | 검색화면 |
|:--:|:--:|:--:|
|작동 화면| <img src="https://github.com/hemg2/ios-unsplash/assets/101572902/a06219a2-5e5a-4b65-8706-03a2f8ff857a" width="400" height="600"/>|<img src="https://github.com/hemg2/ios-unsplash/assets/101572902/fbf79737-49a0-4c90-9721-16795faeb443" width="400" height="600"/>|

</br>

## 🧨 트러블 슈팅
1️⃣ **세그먼트 스크롤 이슈로 인한 커스텀 진행**
🔒 **문제점**
- 이미지 업로드를 위해 세그먼트의 텍스트를 네트워크 요청을 통해 가져오면서 뷰 재사용을 계획했습니다. 하지만 세그먼트 카테고리가 많아 가로 스크롤이 필요한 상황에서, 세그먼트가 스크롤을 지원하지 않는 문제로 인해 진행이 어려웠습니다.

| 세그먼트 스크롤 |
|:--:|
|<img src="https://github.com/hemg2/ios-unsplash/assets/101572902/a87c7ee5-39fa-4275-8819-b9d1539f357b" width="500" height="100"/> |

🔑 **해결방법**
- 이 문제를 해결하기 위해, 세그먼트와 유사하게 동작하는 버튼을 커스텀 디자인하여 사용하였습니다. 많은 카테고리를 수용할 수 있으며 스크롤이 가능해 사용자 인터페이스를 구현할 수 있었습니다.

```swift
private func setupCategoryButtons() {
        var previousButton: UIButton?
        
        items.enumerated().forEach { index, category in
            let action = UIAction(title: category, handler: { [weak self] _ in
                self?.delegate?.categoryDidSelect(at: index)
            })
            
            let button = UIButton(type: .system, primaryAction: action)
            button.tag = index
            button.setTitle(category, for: .normal)
            button.tintColor = .white
            
            scrollView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: scrollView.topAnchor),
                button.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                button.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
            
            if let previousButton = previousButton {
                button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 12).isActive = true
            } else {
                button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
            }
            
            previousButton = button
            buttons.append(button)
        }
        
        if let lastButton = previousButton {
            NSLayoutConstraint.activate([
                lastButton.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20)
            ])
        }
    }
```

<br>

2️⃣ **사진 업로드 속도**
🔒 **문제점**
- 사진의 디테일뷰로 들어가 사진을 확인 할 경우 좌,우 이동시에 사진 업로드가 미리 준비되어있지않아 업로드가 오래 걸리게되었습니다.

| 제스쳐 진행시 사진 |
|:--:|
|<img src="https://github.com/hemg2/ios-unsplash/assets/101572902/c9d23fdb-1b2c-449d-a7fc-62a2b28f1bf1" width="300" height="500"/> |
- 제스쳐를 사용하여 사진의 인덱스에 맞게 사진을 업로드하게 진행했습니다.
```swift
@objc private func handleSwipeToLeft(_ gesture: UISwipeGestureRecognizer) {
        let newFrame = photoDetailView.frame.offsetBy(dx: -view.frame.width, dy: 0)
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.photoDetailView.frame = newFrame
            self?.viewModel.showNextPhoto()
        }) { _ in
            self.photoDetailView.frame = self.view.bounds
        }
    }
```
<br>

🔑 **해결방법**
- 기존의 제스처 기반 사진 업로드 방식에서 컬렉션뷰를 사용하는 방식으로 변경했습니다. 컬렉션뷰를 사용하면 사진들이 미리 준비되고 효율적으로 관리될 수 있어, 사용자 경험이 크게 향상됩니다.

| 컬렉션뷰 사용 |
|:--:|
|<img src="https://github.com/hemg2/ios-unsplash/assets/101572902/29403d91-a329-4716-935e-6042a0e592c1" width="300" height="500"/> |

```swift
 private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout
```

```swift
extension PhotoDetailViewController: UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Detailcell", for: indexPath) as? PhotoDetaillViewCell,
              let photo = viewModel.photos[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.configure(photo: photo, isUIElementsHidden: viewModel.isUIElementsHidden)
        return cell
    }
```

```swift
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
```

<br>

3️⃣ **이미지 레이아웃 변경**
🔒 **문제점** 
- 터치 제스쳐 진행시에 버튼 및 네비게이션바가 사라질때 이미지레이아웃이 변경되는 이슈가 발생했습니다.

| 뷰데이터 히든 이슈|
|:--:|
|<img src="https://github.com/hemg2/ios-unsplash/assets/101572902/11d6cf08-33f4-40bc-9bea-f00cd2a37611" width="300" height="500"/>|
 
```swift
 @objc private func handleTap() {
        guard let navigationController = navigationController else { return }
        let shouldHide = navigationController.navigationBar.isHidden == false
        navigationController.setNavigationBarHidden(shouldHide, animated: true)
        
        photoDetailView.toggleUIElements(shouldHide: shouldHide)
    }

func toggleUIElements(shouldHide: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.likeButton.isHidden = shouldHide
            self.addButton.isHidden = shouldHide
            self.downloadButton.isHidden = shouldHide
        }
    }
```

<br>

🔑 **해결방법** 

| 뷰데이터 알파값 처리 |
|:--:|
|<img src="https://github.com/hemg2/ios-unsplash/assets/101572902/aefb081f-8db8-4dfd-90e4-33818c7e2a13" width="300" height="500"/> |

- `isHidden`처리가 아닌 `alpha` 값을 조절 하여 on/off기능 생성, 진행 했습니다.

```swift
 @objc private func handleTap() {
        guard let navigationController = navigationController else { return }
        let shouldHide = navigationController.navigationBar.alpha == 1
        UIView.animate(withDuration: 0.25) {
            navigationController.navigationBar.alpha = shouldHide ? 0 : 1
            self.photoDetailView.toggleUIElements(shouldHide: shouldHide)
        }
    }

func toggleUIElements(shouldHide: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.likeButton.alpha = shouldHide ? 0 : 1
            self.addButton.alpha = shouldHide ? 0 : 1
            self.downloadButton.alpha = shouldHide ? 0 : 1
        }
    }
```

<br>

## 📚 핵심 경험

🌟 `API` 통신을 통하여 `Network` 구축 진행
`UnsplashEndPoint`, `URLSessionProvider`, `UnsplashRepository` 등의 레이어와 프로토콜을 구현하여 네트워크 통신 구조를 설계했습니다. 프로토콜을 활용하여 인터페이스의 추상화를 진행했으며, 다른 요구 사항에 유연하게 대응할 수 있는 설계를 구현했습니다.

🌟 `MVVVM` 아키텍쳐 구현
`MVVM` 아키텍처를 적용하여, 뷰모델의 상태 변화에 따른 비동기적 화면 업데이트를 구현했습니다. 프로토콜을 통하여 역활을 추상화 하였고 각 계층의 책임을 명확히 했습니다. 아키텍처의 분리를 통해 보다 유지보수가 용이하게 진행했습니다.

🌟 `SwiftUI`를 통하여 뷰 생성
`SwiftUI`를 활용하여 `SearchView`관련하여 인터페이스 구현 진행하여 선언적UI를 통한 뷰 개발을 이해했습니다.

🌟 `CollectionView`를 통하여 뷰 생성
서버로부터 받아온 이미지를 데이터에 맞게 `CollectionView` 셀의 크기를 동적으로 조정하는 기능을 구현했습니다.

🌟 `UserDefaults`를 통하여 좋아요 구현
`UserDefaults`를 활용해 애플리케이션 내 좋아요 기능을 구현했습니다. 사용자가 좋아하는 사진을 로컬 저장소에 저장하여 확인할 수 있게 진행했습니다.

</br>
