% TUGAS PRAKTIKUM 3 %

pkg load image;

% Baca gambar dan ubah ke grayscale
gambar = imread('wanita.jpg');
if size(gambar, 3) == 3
    gambar = rgb2gray(gambar);
end

% Tambahkan 5 jenis noise berbeda ke gambar
noise1 = imnoise(gambar, 'salt & pepper', 0.02);
noise2 = imnoise(gambar, 'gaussian', 0, 0.01);
noise3 = imnoise(gambar, 'speckle', 0.04);
noise4 = imnoise(gambar, 'poisson');

a = 20;  % rentang noise uniform: [-20, 20]
noise5 = uint8(double(gambar) + (2 * a * rand(size(gambar)) - a));  % Uniform noise manual

% Array gambar noisy
daftar_noise = {noise1, noise2, noise3, noise4, noise5};
judul_noise = {
    'Salt & Pepper 0.02', ...
    'Gaussian 0.01', ...
    'Speckle 0.04', ...
    'Poisson', ...
    'Uniform [-20, 20]'};

% Fungsi filter batas (boundary filter)
function G = filter_batas(F)
    [tinggi, lebar] = size(F);
    G = F;
    for y = 2 : tinggi-1
        for x = 2 : lebar-1
            tetangga = [F(y-1,x-1), F(y-1,x), F(y-1,x+1), ...
                        F(y,x-1),             F(y,x+1), ...
                        F(y+1,x-1), F(y+1,x), F(y+1,x+1)];
            minVal = min(tetangga);
            maxVal = max(tetangga);
            pusat = F(y,x);
            if pusat < minVal
                G(y,x) = minVal;
            elseif pusat > maxVal
                G(y,x) = maxVal;
            else
                G(y,x) = pusat;
            end
        end
    end
end

% Tampilkan semua gambar dalam satu figure (3 baris x 6 kolom)
figure;

% Baris 1: Gambar asli
subplot(3, 6, 1);
imshow(gambar);
title('Gambar Asli');

% Kosongkan kolom 2–6 (untuk rata)
for k = 2:6
    subplot(3,6,k); axis off;
end

% Baris 2 dan 3: Gambar noisy dan hasil filter batas
for i = 1:5
    noisy_img = daftar_noise{i};
    filtered_img = filter_batas(noisy_img);

    subplot(3, 6, 6 + i);        % Baris ke-2
    imshow(noisy_img);
    title(['Noise ', num2str(i), ': ', judul_noise{i}]);

    subplot(3, 6, 12 + i);       % Baris ke-3
    imshow(filtered_img);
    title(['Filtered ', num2str(i)]);
end

% Gunakan figure(2) agar tidak bentrok dengan figure sebelumnya
figure(2);

% Baris 1: Gambar Asli
subplot(3, 6, 1);
imshow(gambar);
title('Gambar Asli');

% Kosongkan kolom 2–6 agar tetap rata
for k = 2:6
    subplot(3, 6, k); axis off;
end

% Terapkan Mean Filter dan tampilkan hasilnya
for i = 1:5
    noisy = daftar_noise{i};
    filtered = imfilter(noisy, fspecial('average', [3 3]), 'replicate');

    subplot(3, 6, 6 + i);      % Baris 2: Gambar Noisy
    imshow(noisy);
    title(['Noise ', num2str(i), ': ', judul_noise{i}]);

    subplot(3, 6, 12 + i);     % Baris 3: Setelah Filter Perataan
    imshow(filtered);
    title(['Mean Filter ', num2str(i)]);
end

% Gunakan figure(3) agar tidak bentrok dengan figure sebelumnya
figure(3);

% Baris 1: Gambar Asli
subplot(3, 6, 1);
imshow(gambar);
title('Gambar Asli');

% Kosongkan kolom 2–6 agar tetap rata
for k = 2:6
    subplot(3, 6, k); axis off;
end

% Terapkan Median Filter dan tampilkan hasilnya
for i = 1:5
    noisy = daftar_noise{i};
    filtered = medfilt2(noisy, [3 3]);  % Filter Median 3x3

    subplot(3, 6, 6 + i);      % Baris 2: Gambar Noisy
    imshow(noisy);
    title(['Noise ', num2str(i), ': ', judul_noise{i}]);

    subplot(3, 6, 12 + i);     % Baris 3: Setelah Median Filter
    imshow(filtered);
    title(['Median Filter ', num2str(i)]);
end


%Histogram untuk semua jenis filter diatas%
% Tampilkan histogram untuk gambar asli, noisy, dan hasil filtering
figure(4);
colormap gray;

% Histogram gambar asli
subplot(4, 6, 1);
imhist(gambar);
title('Hist Asli');

% Histogram gambar noisy
for i = 1:5
    subplot(4, 6, i + 1);
    imhist(daftar_noise{i});
    title(['Hist Noise ', num2str(i)]);
end

% Histogram gambar setelah filter batas
for i = 1:5
    filtered = filter_batas(daftar_noise{i});
    subplot(4, 6, 6 + i + 1);
    imhist(filtered);
    title(['Hist Batas ', num2str(i)]);
end

% Histogram gambar setelah mean filter
for i = 1:5
    filtered = imfilter(daftar_noise{i}, fspecial('average', [3 3]), 'replicate');
    subplot(4, 6, 12 + i + 1);
    imhist(filtered);
    title(['Hist Mean ', num2str(i)]);
end

% Histogram gambar setelah median filter
for i = 1:5
    filtered = medfilt2(daftar_noise{i}, [3 3]);
    subplot(4, 6, 18 + i + 1);
    imhist(filtered);
    title(['Hist Median ', num2str(i)]);
end

