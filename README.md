# 🍻 술BAC토리

## 👐 프로젝트 소개
<p align="justify">
  음주량, 음주 시간, 체중, 성별 등을 통해서 혈중 알코올 농도 (BAC)를 손쉽게 계산하는 앱이며, 혈중 알코올 농도 (BAC)가 완전히 분해되는 시간, BAC에 따른 음주운전 시 처벌 단계를 알려주는 앱.
</p>

## 🕖 프로젝트 기간
<p align="justify">
  2023.09.01 ~ 2023.09.09
</p>


## 🚀 기술 스택

#### 언어
* SwiftUI
#### 디자인 패턴
* MVVM 패턴
#### 사용 기술 및 오픈소스 라이브러리
* ACarousel


## 🚀 구현 기능
* 주류 선택
* 개인정보 입력(체중, 성별)
* 음주 정보 입력 (음주량, 음주 시간)
* 주류, 개인정보, 음주 정보를 통한 BAC 계산
* BAC 수치에 따른 위험 요소 계산
* BAC 수치에 따른 알코올 분해 시간 계산
* BAC 수치에 따른 음주 운전 시 처벌 단계


## 🚀 구현 중 발생 문제 및 문제 해결 과정
1. 개인정보 입력 영역에서 성별을 변경해도 변경되지 않는 문제
   <br />
   <br />
   ![성별변경문제화면](https://github.com/Sang-Mini/BACCalculator/assets/105893642/22bdb972-4fea-4af9-9b95-95acdd71dd1b)
   <br />
   <br />
   원인 : Picker에서 사용되는 성별 변수의 타입이 정수였기 때문. 왜?
   <br />
   ![성별변수타입](https://github.com/Sang-Mini/BACCalculator/assets/105893642/a3a96d50-8d13-46f0-84a6-e9767ae11ca2)
   <br />
   실제로 사용되는 타입은 Picker 내부의 Text 즉 문자열 타입이기 때문임. 결국 서로 타입이 안 맞았기 때문에 문제가 발생됨.
   <br />
   해결 : 성별 변수의 타입을 문자열 타입으로 변경해 줬음.
   <br />
   ![성별변수타입변경](https://github.com/Sang-Mini/BACCalculator/assets/105893642/9a9bcf5e-c0df-40e0-bc3e-f895bcbda2fc)

   또 다른 문제 발생 : 위 문제를 변수의 타입을 변경하는 방법으로 해결하면 BAC 계산 로직에서 추가적인 문제가 발생됨. 즉 BAC 계산 로직에서는 성별 변수를 정수로 사용하고 있음. 그렇기 때문에 BAC 계산 로직에서 추가적인 문제가 발생함.
   <br />
   <img width="743" alt="BAC계산함수문제발생" src="https://github.com/Sang-Mini/BACCalculator/assets/105893642/eef2a997-ef5e-4c9e-9ea6-0a14852714c6">


   해결 : 성별 변수의 타입을 이전처럼 정수로 변경 후 Picker 코드를 아래와 같이 수정해 줬음.
   <br />
   <img width="296" alt="성별변수타입정수로변경" src="https://github.com/Sang-Mini/BACCalculator/assets/105893642/6cbbd472-0690-4147-a98d-d8c1eb08eb98">
   <br />
   <img width="444" alt="Picker코드" src="https://github.com/Sang-Mini/BACCalculator/assets/105893642/674b7c43-1d46-42a4-852f-b0b016837b31">
   <br />
   <br />

3. 입력한 음주량에 따른 BAC계산 결과가 잘못나오는 문제 발생
   <br />
   <br />
   원인 : 체중 : 65, 성별 : 남, 음주량 : 1, 음주 시간 : 1로 계산하면 BAC 결과는 0.0364가 나와야 정상, 하지만 실제로 시뮬레이터로 데이터를 입력받아서 결과를 계산하면 -15.111...이라는 잘못된 결과가 나옴. 왜 저런 잘못된 결과가 나오는 걸까 분석하다 보니까 발견한 게 있음. 바로 주량을 11잔으로 바꿔서 계산하면 저런 결과가 나옴. 즉 주량을 11잔으로 입력해서 계산하면 -15.111이라는 결과가 나오는 거임. 나는 분명히 1잔을 입력했지만 11잔으로 계산해버리는 문제였음. 그래서 왜 저런 문제가 발생될까 찾아보다가 String 값이어서 그렇게 알아들을 수 있다는 조언을 받음.
   <br />
   <img width="281" alt="음주정보" src="https://github.com/Sang-Mini/BACCalculator/assets/105893642/ff4ca0f4-0c70-449c-b6bb-6ab6cb8253c7">
   <br />
   위처럼 연속으로 입력받는 값이 String 값이어서 발생될 가능성이 있다는 거임. 그래서 난 브레이크 포인트, print를 통해서 입력되는 값을 확인했지만 값은 아주아주아주 정상적으로 받고 있었음..🥲 그렇다면! 데이터를 입력받는 게 아니러 선택하게 하면 되지 않을까? 생각을 하게 됨..😲 하.지.만 그렇게 해도 결과는 동일..😭
   <br />
   해결 : 그래서 난 결국 처음부터 다시 BAC 계산 전체 로직을 변경하고, 설탕 함유량을 빼고 계산하도록 처리하니까 결과는 잘 나오게 되었음.
   <br />
   <img width="741" alt="BAC계산함수" src="https://github.com/Sang-Mini/BACCalculator/assets/105893642/9912788c-8601-43a0-8025-910cbc43462f">


## 🚀 시연 영상
![알콜마셔요시연영상](https://github.com/Sang-Mini/BACCalculator/assets/105893642/ccdf4e3a-3ec7-4288-899c-246c5f417004) ![알콜마셔요시연영상2](https://github.com/Sang-Mini/BACCalculator/assets/105893642/2629cfc0-5079-4c6f-9a92-c0b39836b271)

## 🤩 배운 점
<p align="justify">
  첫 앱을 출시하면서 처음으로 사용해 본 SwiftUI의 장점에 대해서 알게 되었습니다. 변경되는 코드의 내용을 실시간으로 변경해서 미리 보기를 제공해 주는 preview의 기능이 너무나도 편했습니다.
  실제로 적용해 본 MVVM 패턴, NavigationView 등 다양한 기술에 대해 배웠습니다.
</p>

## 😢 아쉬운 점
<p align="justify">
  입력값은 1이지만 11로 인식하여 계산하는 원인에 대해서 정확히 인지하지 못해서 너무 아쉽습니다.
</p>

## 🫡 앞으로 할 일
<p align="justify">
  주류, 체중, 성별, 음주량, 음주 시간뿐만 아니라 다양한 정보를 통해서 더욱 자세히 결과를 도출하도록 하고 싶습니다.
</p>
