pkg load image;

% 1. Baca gambar dan ubah ke grayscale
img = imread('daun.jpg');
gray = rgb2gray(img);

% 2. Terapkan Gaussian blur (untuk smoothing)
h = fspecial("gaussian", [7 7], 2);  % Kernel Gaussian 7x7, sigma=2
blurred = imfilter(gray, h, 'replicate');

% 3. Terapkan High-Boost Filtering
A = 3;  % Nilai penguat (coba 2.5 - 3 untuk efek jelas)
high_boost = A * double(gray) - double(blurred);
high_boost = uint8(mat2gray(high_boost) * 255);  % Normalisasi ke 0–255

% 4. Tampilkan Sebelum & Sesudah
subplot(1,2,1), imshow(gray), title('Sebelum (Grayscale)');
subplot(1,2,2), imshow(high_boost), title(['Sesudah (High-Boost, A=' num2str(A) ')']);

