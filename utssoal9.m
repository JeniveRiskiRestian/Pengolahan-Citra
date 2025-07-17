% Baca gambar
img = imread('parkiran.jpg');  % Pastikan file berada di folder kerja

% Jika citra berwarna, konversi ke grayscale (opsional)
gray_img = rgb2gray(img);

% Buat kernel Gaussian 2D
sigma = 2;
kernel_size = 5;
[x, y] = meshgrid(-floor(kernel_size/2):floor(kernel_size/2));
gauss_kernel = exp(-(x.^2 + y.^2) / (2*sigma^2));
gauss_kernel = gauss_kernel / sum(gauss_kernel(:));  % Normalisasi

% Terapkan Gaussian blur menggunakan konvolusi
blurred_img = conv2(double(gray_img), gauss_kernel, 'same');

% Tampilkan hasil
figure;
subplot(1,2,1);
imshow(gray_img);
title('Gambar Asli (Grayscale)');

subplot(1,2,2);
imshow(uint8(blurred_img));
title('Gambar Setelah Gaussian Blur');

