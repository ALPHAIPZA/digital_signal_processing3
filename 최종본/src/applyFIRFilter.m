% --- File: src/applyFIRFilter.m ---
function filteredData = applyFIRFilter(audioData, fs)
    % 대역통과 FIR 필터를 오디오 데이터에 적용
    % 입력:
    %   - audioData: 입력 오디오 신호 데이터 (벡터 형식)
    %   - fs: 샘플링 주파수 (Hz)
    % 출력:
    %   - filteredData: 필터링된 오디오 데이터

    % 통과 대역 범위 정의 (Hz 단위)
    lowerBound = 50;     % 하한 주파수
    upperBound = 1000;   % 상한 주파수

    % 차단 주파수를 정규화 (0 ~ 1 범위)
    nyquist = fs / 2; % 나이퀴스트 주파수
    normalizedCutoff = [lowerBound, upperBound] / nyquist;

    % 대역통과 FIR 필터 설계
    filterOrder = 10000; % 필터 차수 (값이 클수록 필터가 정밀해지지만 계산량 증가)
    filterCoeffs = fir1(filterOrder, normalizedCutoff, 'bandpass');

    % FIR 필터를 오디오 데이터에 적용
    filteredData = filter(filterCoeffs, 1, audioData);

    % 디버깅용 로그 출력
    disp(['FIR 대역통과 필터 적용 (', num2str(lowerBound), 'Hz ~ ', num2str(upperBound), 'Hz).']);
end
