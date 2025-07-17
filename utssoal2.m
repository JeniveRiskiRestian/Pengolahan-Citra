clc;
clear;

% Muat paket image
pkg load image;

% Baca gambar dan konversi ke grayscale
img_rgb = imread('onepiece.jpg');
img_gray = rgb2gray(img_rgb);
img_gray = double(img_gray);  % ubah ke double agar perhitungan akurat

% Fungsi kuantisasi
function out = quantize_gray(img, level)
  step = 256 / level;
  out = floor(img / step) * step + step/2;
  out = uint8(out);
endfunction

% Kuantisasi ke 2, 4, dan 8 level
img_2  = quantize_gray(img_gray, 2);
img_4  = quantize_gray(img_gray, 4);
img_8  = quantize_gray(img_gray, 8);

% Tampilkan hasil dalam subplot
figure('Name', 'Kuantisasi Grayscale', 'NumberTitle', 'off');

subplot(1,4,1);
imshow(uint8(img_gray));
title('Grayscale Asli');

subplot(1,4,2);
imshow(img_2);
title('Kuantisasi 2 level');

subplot(1,4,3);
imshow(img_4);
title('Kuantisasi 4 level');

subplot(1,4,4);
imshow(img_8);
title('Kuantisasi 8 level');

% Simpan hasil
imwrite(uint8(img_gray), 'gray_asli.jpg');
imwrite(img_2, 'gray_2level.jpg');
imwrite(img_4, 'gray_4level.jpg');
imwrite(img_8, 'gray_8level.jpg');

