function lineCallback(src,~)
%Callback function
%   此处显示详细说明
    global CorrectIndex_g;
    src.Color = 'red';
    CorrectIndex_g(CorrectIndex_g == str2double(src.Tag)) = [];
end

