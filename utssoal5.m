pkg load image;  % Pastikan paket image sudah aktif

% 1. Membaca gambar
img = imread('koala.jpg');
img = im2double(img);  % Konversi ke double untuk proses filter

% 2. Menambahkan noise salt & pepper
noisy_img = imnoise(img, 'salt & pepper', 0.05);  % 5% noise

% 3. Terapkan median filter 3x3
median_filtered = zeros(size(noisy_img));
for i = 1:size(img, 3)
    median_filtered(:, :, i) = medfilt2(noisy_img(:, :, i), [3 3]);
end

% 4. Terapkan mean filter 3x3
mean_filter = fspecial('average', [3 3]);
mean_filtered = zeros(size(noisy_img));
for i = 1:size(img, 3)
    mean_filtered(:, :, i) = imfilter(noisy_img(:, :, i), mean_filter, 'replicate');
end

% 5. Tampilkan hasil
figure;
subplot(1,4,1), imshow(img), title('Original');
subplot(1,4,2), imshow(noisy_img), title('Noisy (Salt & Pepper)');
subplot(1,4,3), imshow(median_filtered), title('Median Filter (3x3)');
subplot(1,4,4), imshow(mean_filtered), title('Mean Filter (3x3)');

