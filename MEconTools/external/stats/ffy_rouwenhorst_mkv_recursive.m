function [m] = ffy_rouwenhorst_mkv_recursive(p,q,h)
%%
% Rouwenhorst(1995)

if h == 1
    m = 1;
else
    m = 1;
    for i = 1:h-1
        zv = zeros(1,i)';
        m = p*[[m zv];[zv' 0]] + (1-p)*[[zv m];[0 zv']] + (1-q)*[[zv' 0];[m zv]] + q*[[0 zv'];[zv m]];
        m = m/2;
        m(1,:) = 2*m(1,:);
        m(length(m),:) = 2*m(length(m),:);
    end
end

end
