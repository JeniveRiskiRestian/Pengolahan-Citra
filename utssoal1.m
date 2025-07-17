clc;
clear;

% Muat paket image
pkg load image;

% Baca gambar
img_path = 'spongebob.jpg';
if exist(img_path, 'file') == 2
    img_rgb = imread(img_path);
else

endif

% Konversi ke grayscale
img_gray = rgb2gray(img_rgb);

% Ambil threshold otomatis (Otsu)
threshold = graythresh(img_gray);  % antara 0 - 1

% Konversi grayscale (uint8) ke double (0 - 1)
img_gray_norm = im2double(img_gray);

% Buat citra biner secara manual
img_binary = img_gray_norm > threshold;

% Tampilkan hasil dalam satu subplot
figure('Name', 'Konversi Citra', 'NumberTitle', 'off');

subplot(1,3,1);
imshow(img_rgb);
title('Citra RGB (Berwarna)');

subplot(1,3,2);
imshow(img_gray);
title('Citra Grayscale');

subplot(1,3,3);
imshow(img_binary);
title('Citra Biner');

