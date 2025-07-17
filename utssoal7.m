pkg load image;

% 1. Baca gambar
img = imread('papankarangan.jpg');

% 2. Rotasikan gambar -10 derajat dengan interpolasi bilinear
rotated = imrotate(img, -10, 'bilinear');

% 3. Perbesar gambar (skala 1.5x)
scale = 1.5;
resized = imresize(rotated, scale);

% 4. Tampilkan perbandingan
figure;
subplot(1, 2, 1), imshow(img), title('Sebelum');
subplot(1, 2, 2), imshow(resized), title('Sesudah (Rotasi + Perbesar)');

