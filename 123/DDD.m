x = (0:0.005:10)';
N= size(x,1);
widthb = zeros(N,1);
prompt = 'How many partition of beam you want for width variation?';
bpart = input(prompt);
for i=1:bpart
    string1 = sprintf('Starting point of the parition no. %d',i);
    prompt = string1;
    bstart = input(prompt);
    string2 = sprintf('Ending point of the partition no. %d',i);
    prompt = string2;
    bend = input(prompt);
    string3 = sprintf('Which degree of equation you want to fit for partition no. %d ? - ',i);
    prompt = string3;
    bdeg = input(prompt);
    str = sprintf('You need to provide atleast %d points to fit the equation',bdeg+1);
    display(str);
    point = zeros(1,bdeg+1);
    wb = zeros(bdeg+1,1);
    for g = 1: bdeg+1
        str = sprintf('x for point no. %d. - ',g);
        prompt = str;
        point(g) = input(prompt);
        str2 = sprintf('width at point no. %d. - ',g);
        prompt = str2;
        wb(g) = input(prompt);
        l=0;
        while l <1000
            if(wb(g)<=0)
                display('negative value not possible for width');
                prompt = 'please add positive value';
                wb(g) = input(prompt);
            else
                l = 1000;
                break
            end
                l= l+1;
        end
    end
    matA = zeros(bdeg+1,bdeg+1);
    for j = 1 : bdeg+1
        for k = 1:bdeg+1
            matA(j,k) = point(j)^(k-1);
        end
    end
    coeff = (matA^(-1))*wb;
    for S=1:N
        if(x(S)>=bstart)
            for p = 1:bdeg+1
                widthb(S) = widthb(S) + coeff(p)*((x(S))^(p-1));
            if(x(S)>=bend)
                widthb(S) = widthb(S) - coeff(p)*((x(S))^(p-1));
            end
            end
        end
    end
    
end