function lineCallback(src,~)
%Callback function
%   �˴���ʾ��ϸ˵��
    global CorrectIndex_g;
    src.Color = 'red';
    CorrectIndex_g(CorrectIndex_g == str2double(src.Tag)) = [];
end

