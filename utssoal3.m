pkg load image;  % Aktifkan package image

% 1. Baca gambar warna
img = imread('lakilakiredup.jpg');

% 2. Ubah ke double dan tingkatkan kecerahan
img_double = im2double(img);
bright_img = img_double * 2.0;
bright_img = min(bright_img, 1.0);  % Hindari nilai > 1

% 3. Tampilkan gambar asli (warna) dan terang (warna)
figure;
subplot(1, 2, 1); imshow(img); title('Gambar Asli');
subplot(1, 2, 2); imshow(bright_img); title('Setelah Diterangkan');
drawnow; pause(0.1);

% 4. Tampilkan histogram berdasarkan versi grayscale-nya
gray = rgb2gray(img);
bright_gray = rgb2gray(bright_img);

figure;
subplot(2, 1, 1);
imhist(gray); title('Histogram Sebelum Diterangkan');

subplot(2, 1, 2);
imhist(uint8(bright_gray * 255)); title('Histogram Setelah Diterangkan');
drawnow; pause(0.1);

