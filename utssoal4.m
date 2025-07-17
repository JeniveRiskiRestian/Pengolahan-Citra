% Membaca gambar
img = imread('jefri.jpg');

% Konversi ke grayscale jika perlu
if size(img, 3) == 3
    gray_img = rgb2gray(img);
else
    gray_img = img;
end

% Ekualisasi histogram
equalized_img = histeq(gray_img);

% Menampilkan citra
figure;
subplot(2, 2, 1);
imshow(gray_img);
title('Citra Sebelum Ekualisasi');

subplot(2, 2, 2);
imshow(equalized_img);
title('Citra Setelah Ekualisasi');

% Menampilkan histogram
subplot(2, 2, 3);
imhist(gray_img);
title('Histogram Sebelum');

subplot(2, 2, 4);
imhist(equalized_img);
title('Histogram Setelah');

% Menyimpan hasil citra ekualisasi (opsional)
imwrite(equalized_img, 'jefri_equalized.jpg');

