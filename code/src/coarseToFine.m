function [u, k] = coarseToFine(f, blind_params, params)

MK = blind_params.MK;
NK = blind_params.NK;

u = padarray(f,[floor(MK/2) floor(NK/2)],'replicate');
k = ones(MK,NK)/MK/NK;

[fp, Mp, Np, MKp, NKp, lambdas, scales] = buildPyramid(f, MK, NK,...
                params.finalLambda, params.lambdaMultiplier, ...
                params.interpolationMethod, params.kernelSizeMultiplier,...
                params.maxLambda);

% Multiscale Processing
for scale=scales:-1:1
    Ms = Mp{scale,1};
    Ns = Np{scale,1};
    
    MKs = MKp{scale,1};
    NKs = NKp{scale,1}; 
    fs = fp{scale,1};
    lambda = lambdas(scale);

    u = imresize(u, [(Ms + MKs - 1) (Ns + NKs - 1)], 'Method',...
        params.interpolationMethod);

    k = imresize(k, [MKs NKs], 'Method', params.interpolationMethod);
    k = k/sum(k(:));
    
    fprintf('Working on Scale: %d with pyramid_lambda=%f and kernel size [%d,%d] for %d iterations.\n',...
        scale,lambda,MKs,NKs,blind_params.niters);

    blind_params.MK = MKs;
    blind_params.NK = NKs;
    tic;
	[u, k] = prida(fs, u, k, lambda, blind_params);
    toc;
end