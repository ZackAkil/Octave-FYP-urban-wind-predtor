function r = diffRot(p, v)
%calculates difference between rotational degree values
% e.g 350 degrees is 15 degrees away from 5 degrees

a = [abs(p-v),abs((p+360)-v),abs((p-360)-v)];

r = min(a')';

end
