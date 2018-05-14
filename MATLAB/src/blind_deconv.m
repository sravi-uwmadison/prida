function [u, k] = blind_deconv(f, lambda, params)

f = im2double(f);
[M, N, ~] = size(f);

% make sure that the image size is an odd number (on both axes)
if (mod(M,2) == 0)
    f = f(1:end-1,:,:);
end
if (mod(N,2) == 0)
    f = f(:,1:end-1,:);
end

% parameters for pyramid building (adapted from Perrone et al)
ctf_params.lambdaMultiplier = 1.9;
ctf_params.maxLambda = 1.1e-1;
ctf_params.finalLambda = lambda;
ctf_params.kernelSizeMultiplier = 1.1;
ctf_params.interpolationMethod = 'bilinear';

[u, k] = coarseToFine(f, params, ctf_params);
