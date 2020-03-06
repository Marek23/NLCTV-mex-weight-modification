clc; clear;

mex main.c;

%% parametry algorytmu
imageName  = 'test.png';
p_r   = 3;
s_r   = 8;
lamda = .01;
sigma = 5;
r     = 2;
sw    = 3; %gdy sw = 1 bez modyfikacji , sw>1 -> to modyfikacja wagi.

%%
f0=imread(imageName);

%figure; imagesc(f0); colormap(gray); axis off; axis equal;
f0=double(f0);
[m,n,c]=size(f0);

p_s = p_r*2+1;
s_s = s_r*2+1;
if sw>1
    P_R = p_r*sw+1;
else
    P_R = 0;
end
P_S = 2*P_R+1;
if sw>1
    t_r = P_R+s_r;
else
    t_r = p_r+s_r;
end

M   = m+2*t_r;
N   = n+2*t_r;

BrokenAreaColor=255;

kernel  = fspecial('gaussian',p_s,sigma);
kernelk = fspecial('gaussian',P_S,sigma);

phi=double(1-((f0(:,:,1) == 0) & ...
              (f0(:,:,2) == BrokenAreaColor) & ...
              (f0(:,:,3) == 0)));

phi=padarray(phi,[t_r t_r],'symmetric');
PHI=phi;

u0=f0;

tic
u0r = main(m,n,c,u0(:),...
    M,N,r,p_s,kernel(:),...
    P_S,kernelk(:),t_r,s_r,p_r,sw,phi(:),...
    PHI(:),s_s,lamda,f0(:));
t = toc;

u0 = reshape(u0r,[m,n,c]);
%figure; imagesc(uint8(u0)); colormap(gray); axis off; axis equal;

imwrite(uint8(u0),['s_r_' num2str(s_r) 'p_r' num2str(p_r) 'h_' num2str(r) 'sw_' num2str(sw) 't_' num2str(t) 'output.png']);
