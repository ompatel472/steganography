clc
clear all
close all
warning off 

%Carrier image
a=imread('carrier_image.jpg');
nexttile;
imshow(a);
title('Carrier Image');

%Original image
x=imread('Original_image.jpg');
nexttile;
imshow(x);
title('Secret Img');

y=rgb2gray(x);
nexttile;
imshow(y);
title('RGB Image');

z=imnoise(y,'salt & pepper',.7);
nexttile;
imshow(z);
title('RGB Noise Img');

z1=filter2(fspecial('average',3),z)/255;
nexttile;
imshow(z1);
title('Filter RGB Noise Img');

[r c g]=size(a);

x=imresize(x,[r c]);

ra=a(:,:,1);
ga=a(:,:,2);
ba=a(:,:,3);
rx=x(:,:,1);
gx=x(:,:,2);
bx=x(:,:,3);

sk=uint8(rand(r,c)*255);%Secret key

rx=bitxor(rx,sk);
gx=bitxor(gx,sk);
bx=bitxor(bx,sk);
nexttile;
imshow(cat(3,rx,gx,bx));
title('Encrypted Secret Msg');

for i=1:r
    for j=1:c
       nc(i,j)= bitand(ra(i,j),254);
       ns(i,j)= bitand(rx(i,j),128);
       ds(i,j)=ns(i,j)/128;
       fr(i,j)=nc(i,j)+ds(i,j);
    end
end

redsteg=fr;
for i=1:r
    for j=1:c
       nc(i,j)= bitand(ga(i,j),254);
       ns(i,j)= bitand(gx(i,j),128);
       ds(i,j)=ns(i,j)/128;
       fr(i,j)=nc(i,j)+ds(i,j);
    end
end

greensteg=fr;
for i=1:r
    for j=1:c
       nc(i,j)= bitand(ba(i,j),254);
       ns(i,j)= bitand(bx(i,j),128);
       ds(i,j)=ns(i,j)/128;
       fr(i,j)=nc(i,j)+ds(i,j);
    end
end

bluesteg=fr;
finalsteg=cat(3,redsteg,greensteg,bluesteg);
redstegr=finalsteg(:,:,1);
greenstegr=finalsteg(:,:,2);
bluestegr=finalsteg(:,:,3);
nexttile;
imshow(finalsteg);
title('Stegmented Img');

for i=1:r
    for j=1:c
        nc(i,j)=bitand(redstegr(i,j),1);
        ms(i,j)=nc(i,j)*128;
    end
end

recoveredr=ms;
for i=1:r
    for j=1:c
        nc(i,j)=bitand(greenstegr(i,j),1);
        ms(i,j)=nc(i,j)*128;
    end
end

recoveredg=ms;
for i=1:r
    for j=1:c
        nc(i,j)=bitand(bluestegr(i,j),1);
        ms(i,j)=nc(i,j)*128;
    end
end

recoveredb=ms;
output=cat(3,recoveredr,recoveredg,recoveredb);
nexttile;
imshow(output);
title('Recovered Encrypted Img');

red_band=bitxor(output(:,:,1),sk);
green_band=bitxor(output(:,:,2),sk);
blue_band=bitxor(output(:,:,3),sk);
combined=cat(3,red_band,green_band,blue_band);
nexttile;
imshow(combined);
title('Decrypted Secret Msg');

%Entropy of the image
e = entropy(a)

%Histogram of the Carrier Image
figure(2);
imhist(a)
title('Histogram of Carrier image')
xlabel('Pixel Values')
ylabel('Number of Pixels')

%Histogram of the Original Image
figure(3);
imhist(x)
title('Histogram of Original image')
xlabel('Pixel Values')
ylabel('Number of Pixels')