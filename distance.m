fs = 48000;
audioFrameLength = 1024;
deviceReader = audioDeviceReader(...
 'Device', 'miniDSP ASIO Driver',...
 'Driver', 'ASIO', ...
 'SampleRate', fs, ...
 'NumChannels', 16 ,...
 'OutputDataType','double',...
 'SamplesPerFrame', audioFrameLength);
setup(deviceReader);
% fileWriter = dsp.AudioFileWriter(...
%     'mySpeech.wav',...
%     'FileFormat','WAV');
 disp('Speak into microphone now.')
tic;
i=1;
mymax152 = zeros(1,25);
mymax12 = zeros(1,25);
mymax115 = zeros(1,25);
ind152 = zeros(1,25);
ind12 = zeros(1,25);
ind115 = zeros(1,25);


while toc < 1
    acquiredAudio = deviceReader();
    plot(acquiredAudio(1:end,[1 2 15]));
    drawnow
    rcc1to2= zeros(1,683);
    rcc15to2= zeros(1,683);
    rcc1to15= zeros(1,683);

    for p = 1:683
        rcc15to2(p) = sum(acquiredAudio (342:682,15).* acquiredAudio(1+p:341+p,2));
        rcc1to2(p) = sum(acquiredAudio (342:682,1).* acquiredAudio(1+p:341+p,2));
        rcc1to15(p) = sum(acquiredAudio (342:682,1).* acquiredAudio(1+p:341+p,15));
    end
    
    [mymax152(i),ind152(i)] = max(rcc15to2);
    [mymax12(i),ind12(i)] = max(rcc1to2);
    [mymax115(i),ind115(i)] = max(rcc1to15);

    index152 = mode(ind152);
    index12 = mode(ind12);
    index115 = mode(ind115);

    if index152 == 0
        index152 = ind152(i) ;
    end
    if index12 == 0
        index12 = ind12(i) ;
    end
    if index115 == 0
        index115 = ind115(i) ;
    end
    i = i+1;
%     fileWriter(acquiredAudio);
end
index152 = index152 - 341;
index12 = index12 - 341;
index115 = index115 - 341;
disp('Recording complete.');
disp('r15-r2 = (in cm) ');
disp(index152 * 34.3/48);
disp('r1-r2 = (in cm) ');
disp(index12 * 34.3/48);
disp('r1-r15 = (in cm) ');
disp(index115 * 34.3/48);
release (deviceReader);
% release (fileWriter);



