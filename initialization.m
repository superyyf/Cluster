function   initialization()
%Initialize
% 
addpath("./vlfeat/toolbox");
addpath("./data");
addpath("./data/uav");
addpath("./functions");

vl_setup;

mex -setup c++
mex mvMismatches.cpp

end

