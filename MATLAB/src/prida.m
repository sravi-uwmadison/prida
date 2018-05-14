function [u,k] = prida(f,u,k,lambda,params)

[M, N, C] = size(f);

gradu = zeros(M+params.MK-1,N+params.NK-1,C);
gradk = zeros(size(k));

for it=1:params.niters
    %% Update the Sharp Image
    for c=1:C
        gradu(:,:,c) = conv2(conv2(u(:,:,c), k, 'valid') - f(:,:,c),...
                rot90(k,2), 'full');
    end
        
    gradTV = gradTVcc(u);
    gradu = (gradu - lambda*gradTV);
    
    sf = 1e-3*max(u(:))/max(1e-31,max(max(abs(gradu(:)))));
    u_new   = u - sf*gradu;
    
    %% Update the Blur Kernel
    gradk = zeros(size(gradk));
    for c=1:C
        gradk  = gradk + conv2(rot90(u(:,:,c), 2),...
                (conv2(u(:,:,c), k, 'valid') - f(:,:,c)), 'valid');
    end

    sh = 1e-3*max(k(:))/max(1e-31,max(max(abs(gradk))));
    
    % MD Update
    etai = sh./(k+eps);
    bigM = 1000;
    MDS = k.*min(exp(-etai.*gradk),bigM);
    k_new = MDS/sum(sum((MDS)));
    
    
    u = u_new;
    k = k_new;
    
end

