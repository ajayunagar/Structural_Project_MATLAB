mpload=1;
L = 15;
x = (0:1/1000:L)';
N = size(x,1);
deflection = zeros(N,1);

for S=1:N
    mpldis = x(S);
    defcofactor = zeros(support,support);
    defMoment = zeros(support,1);
  for j = 1:2
    
        defMoment(j) = defMoment(j)-(mpload *(sdis(j)-mpldis));
    
  end
  for h = 1:hinge
    
        if(mpldis <= hdis(h))
            defMoment(h+2) = defMoment(h+2) - mpload*(hdis(h) - mpldis);
        end
    
  end
  for j=1:2
    for s = 1:support
        defcofactor(j,s) = sdis(s) - sdis(j);
    end
  end
  for h = 1:hinge
    for s = 1:support
        if(sdis(s)<=hdis(h))
            defcofactor(h+2,s) = sdis(s) - hdis(h);
        end
    end
  end
defReaction = defcofactor^-1 * defMoment;
mplM = zeros(N,1);
  for Z = 1:N
        if(mpldis <= x(Z))
            
            mplM(Z) = mplM(Z) - mpload*(x(Z)-mpldis);
        end
    
    for r = 1:support
        if(sdis(r)<=x(Z))
            mplM(Z) = mplM(Z) + defReaction(r)*(x(Z) - sdis(r));
        end
    end
    
  end

end