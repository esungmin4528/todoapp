# Smart Todo (스마트 할 일 관리 앱)

SwiftUI와 MVVM 아키텍처를 기반으로 개발한 iOS 할 일 관리(Todo) 애플리케이션입니다.
사용자가 일정을 쉽고 효율적으로 관리할 수 있도록 직관적인 UI와 다양한 관리 기능을 제공합니다.

---

## 주요 기능

**할 일 관리(CRUD)**

  * 할 일 추가, 수정, 삭제
  * 완료 여부 체크
  * 앱 종료 후에도 데이터 유지(UserDefaults)

  **검색 및 필터**

  * 제목 검색
  * 카테고리별 필터
  * 중요도별 필터
  * 완료/미완료 목록 조회

**캘린더 기능**

  * 날짜별 할 일 확인
  * 선택한 날짜의 일정 관리
  * 일정이 있는 날짜 표시

**통계 기능**

  * 전체 완료율 확인
  * 카테고리별 할 일 분포 확인
  * Charts를 활용한 시각화

**사용자 편의 기능**

  * 다크 모드 지원
  * 스와이프 삭제
  * Context Menu 지원
  * 직관적인 카드형 UI

---

## Tech Stack

* **Language:** Swift
* **Framework:** SwiftUI (iOS 17+)
* **Architecture:** MVVM
* **State Management:** @Observable
* **Data Persistence:** UserDefaults, Codable
* **UI Components:** NavigationStack, TabView, Charts

---

## 프로젝트 구조

* `Todo.swift` : Todo 모델 및 데이터 구조 정의
* `TodoViewModel.swift` : 비즈니스 로직 및 데이터 관리
* `MainTabView.swift` : 메인 탭(Home / Calendar / Statistics / Settings)
* `ContentView.swift` : 할 일 목록 및 검색·필터 화면
* `CalendarView.swift` : 날짜별 일정 관리 화면
* `StatisticsView.swift` : 완료율 및 통계 화면
* `AddTodoView.swift` : 할 일 추가 화면
* `EditTodoView.swift` : 할 일 수정 화면

---

## 개발 목적

효율적인 일정 관리와 직관적인 사용자 경험을 제공하여 누구나 쉽고 편리하게 할 일을 관리할 수 있는 애플리케이션을 만드는 것을 목표로 개발하였습니다.

---

