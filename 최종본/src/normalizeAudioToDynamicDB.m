function normalizedAudio = normalizeAudioToDynamicDB(audioData, targetDB)
    % 오디오 신호를 특정 dB 수준으로 동적으로 정규화
    % 입력:
    %   - audioData: 입력 오디오 신호 (시간 도메인)
    %   - targetDB: 목표 RMS 수준 (dB 단위)
    % 출력:
    %   - normalizedAudio: 목표 RMS 수준으로 정규화된 오디오 신호

    % 입력 신호의 RMS 계산
    rmsCurrent = sqrt(mean(audioData .^ 2));
    
    % 목표 RMS를 선형 스케일로 변환
    rmsTarget = 10^(targetDB / 20);
    
    % 스케일링 계수 계산
    scalingFactor = rmsTarget / max(rmsCurrent, eps);
    
    % 스케일링 계수 적용
    scaledAudio = audioData * scalingFactor;

    % 절대 피크 값이 1.2를 초과하는 경우에만 피크 정규화 적용
    % 정규화 처리를 하지 않으면 신호가 깨짐
    maxAbsValue = max(abs(scaledAudio));
    if maxAbsValue > 1.2
        disp('클리핑 방지를 위해 피크 정규화를 적용했습니다.');
        scaledAudio = scaledAudio / maxAbsValue;
    end

    % 최종 오디오가 [-1.0, 1.0] 범위 내에 있도록 보장
    normalizedAudio = max(min(scaledAudio, 1.0), -1.0);

    % 디버깅: RMS 값 및 스케일링 정보 출력
    disp(['현재 RMS (dB): ', num2str(20 * log10(rmsCurrent))]);
    disp(['목표 RMS (dB): ', num2str(targetDB)]);
end
