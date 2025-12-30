# dondothat-server
Don do that 팀프로젝트 - 백엔드 파트에서 제가 맡은 역할은 다음과 같습니다.
- LLM을 활용한 소비내역 카테고리 분류 시스템
- LLM을 활용한 사용자 맞춤 챌린지 추천 시스템
- 저금통 API 설계
- 챌린지 성공/실패 판정 로직 설계
</br>

## LLM 소비 카테고리 분류 시스템
<img width="1913" height="1079" alt="image" src="https://github.com/user-attachments/assets/2f9e945b-0f55-46fa-b706-f919d3a740a1" />

- 입출금 계좌 데이터 연동 시 카드와 달리 업장 카테고리 정보가 제공되지 않아 자체 카테고리 분류 로직을 설계.
- 주요 키워드(ex.프랜차이즈 상호명)로 1차 필터링을 수행하고, 남은 항목만 LLM이 판단하는 하이브리드 방식을 고안.
- 
</br></br>

<img width="1919" height="1070" alt="image" src="https://github.com/user-attachments/assets/5f4b84c3-bc50-4d50-b5a1-605da59e3451" />
<img width="1914" height="1075" alt="image" src="https://github.com/user-attachments/assets/8c9fb047-4fab-4047-8b25-a3783c953a9b" />

- 한번에 많은 양의 데이터 입력 시에는 비동기 호출을 적용하여 응답 속도를 개선.
- 배치와 세마포어 사이즈에 따른 테스트를 진행하여 속도와 비용 면에서 최적의 값을 적용, 평균 응답 속도를 약 65% 단축.
- 출력형식 강제, 응답 유효성 검사 및 비정상 출력시 기본값 폴백을 적용하여 안정성을 보장.
- 
</br></br>

## LLM 사용자 맞춤 챌린지 추천 시스템
<img width="1916" height="1075" alt="image" src="https://github.com/user-attachments/assets/be502b7f-d031-4376-ae8a-ee45bb394839" />

- 사용자의 소비 데이터를 기반으로 LLM이 적절한 챌린지를 추천해주는 기능.
- 출력형식 강제, 응답 유효성 검사 및 비정상 출력시 기본값 폴백을 적용하여 안정성을 보장.
- 
</br></br>

## 저금통 API 설계
<img width="1940" height="1096" alt="image" src="https://github.com/user-attachments/assets/879b4b28-f9cd-49fd-9b8a-1ea395272e90" />

- 챌린지 성공시 아낀 금액이 저금통 계좌로 이체되는 기능.
- 원장 테이블 설계 및 유니크키 지정을 통한 멱등성 로직 설계.
- 저금내역 조회 시 성능 개선을 위한 인덱싱 적용.
- 
</br></br>

## 챌린지 성공/실패 판정 로직 설계
<img width="1940" height="1096" alt="image" src="https://github.com/user-attachments/assets/3cc31a88-256c-4f7e-ab36-89e30e7df770" />

- 매일 밤 자정, 챌린지를 진행중인 모든 사용자의 당일 소비내역을 확인한 뒤 실패/성공 처리를 하는 스케줄러.
(고도화 예정)
