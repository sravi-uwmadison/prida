addpath('src/');

% input path
dataPath = fullfile('data');
% filename
fName = 'obama.png';
% output path
resPath = fullfile('res');

% read in image
f = imread(fullfile(dataPath,fName));
f = imresize(f,0.5);

% parameter settings
lambda = 2e-4;
params.MK = 31;
params.NK = 31;
params.niters = 200 ;

[u, k] = blind_deconv(f,lambda,params);

% save out image
[~,imgname,~] = fileparts(fName);
imwrite(u,fullfile(resPath, [imgname '_recov.png']));
imwrite(k,fullfile(resPath, [imgname '_kernel.png']));
