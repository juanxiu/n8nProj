# 간이 옵저버빌리티 장치 만들기

## 목적

- 의사 파일시스템 `procfs`과 `procfs`가 갖는 파일을 이해하고, 이를 활용하여 시스템 지표를 직접 측정한다.
- 옵저버빌리티 도구 `top`, `free`가 `procfs`를 사용하고 있음을 이해한다.
- 셸 스크립팅를 익힌다.
- `n8n`을 사용해 자동화를 구축하는 방법을 학습한다.

## 셸 스크립트

- 의사 파일시스템 `procfs`의 파일 `/proc/stat`, `/proc/meminfo`를 사용해 CPU, 메모리 지표를 측정한다.
  - `proc/stat`: 전체 cpu 시간, cpu idle 시간을 측정하고 1초 후 같은 방법으로 2가지 값을 다시 측정한다. 1초 전 값과 1초 후 값을 비교해 CPU 사용량을 계산한다.
  - `proc/meminfo`: `MemTotal`, `MemAvailable` 값을 통해 현재 메모리 사용량을 계산한다.
- `awk` 명령어를 통해 해당 파일의 지표 값을 가져오고 연산한다.

## n8n 워크플로우

![n8n workflow image](https://github.com/user-attachments/assets/98b39cd9-3431-40e2-8651-300c2071acbc)

1. scheduler Trigger 노드로 해당 워크플로우가 5분에 한 번씩 실행되도록 설정한다.
2. SSH 노드를 통해 스크립트를 실행 가능한 사용자로 접속해 스크립트를 실행한다.
3. Filter 노드를 통해 실행한 스크립트가 `stdout`으로 출력한 CPU, MEM 지표 값이 임계값을 넘었는지 체크한다.
4. 임계값을 넘은 경우, discord 노드를 통해 메시지를 채널로 전송한다. 

## 테스트 결과

![discord message image](https://github.com/user-attachments/assets/fa1d018e-7d01-4620-a836-8f18192347c0)

- CPU, MEM 지표가 설정한 임계값을 초과하는 경우, 디스코드 채널로 메시지가 전송된다.

---

- 아래의 벨로그 글에 더 자세한 구현사항을 작성했다.
  - [n8n + 셸 스크립트 자동화](https://velog.io/@mjttong/n8n-%EC%85%B8-%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8-%EC%9E%90%EB%8F%99%ED%99%94)
  - [CPU, MEM 지표 확인하기](https://velog.io/@mjttong/procfs%EB%A5%BC-%ED%86%B5%ED%95%9C-CPU-MEM-%EC%A7%80%ED%91%9C-%EA%B3%84%EC%82%B0%ED%95%98%EA%B8%B0)
