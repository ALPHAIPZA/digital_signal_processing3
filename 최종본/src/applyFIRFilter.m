% --- File: src/applyFIRFilter.m ---
function filteredData = applyFIRFilter(audioData, fs)
    % �뿪��� FIR ���͸� ����� �����Ϳ� ����
    % �Է�:
    %   - audioData: �Է� ����� ��ȣ ������ (���� ����)
    %   - fs: ���ø� ���ļ� (Hz)
    % ���:
    %   - filteredData: ���͸��� ����� ������

    % ��� �뿪 ���� ���� (Hz ����)
    lowerBound = 50;     % ���� ���ļ�
    upperBound = 1000;   % ���� ���ļ�

    % ���� ���ļ��� ����ȭ (0 ~ 1 ����)
    nyquist = fs / 2; % ��������Ʈ ���ļ�
    normalizedCutoff = [lowerBound, upperBound] / nyquist;

    % �뿪��� FIR ���� ����
    filterOrder = 10000; % ���� ���� (���� Ŭ���� ���Ͱ� ������������ ��귮 ����)
    filterCoeffs = fir1(filterOrder, normalizedCutoff, 'bandpass');

    % FIR ���͸� ����� �����Ϳ� ����
    filteredData = filter(filterCoeffs, 1, audioData);

    % ������ �α� ���
    disp(['FIR �뿪��� ���� ���� (', num2str(lowerBound), 'Hz ~ ', num2str(upperBound), 'Hz).']);
end
