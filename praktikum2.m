% TUGAS PRAKTIKUM 2 %

pkg load image;

% 1. Histogram RGB dan Grayscale
img = imread('onepiece.jpg');
img_gray = rgb2gray(img);

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

figure(1); clf;
subplot(2,2,1); imshow(img); title('Gambar Asli');
subplot(2,2,2); imshow(img_gray); title('Grayscale');
subplot(2,2,3); imhist(img_gray); title('Histogram Grayscale');
subplot(2,2,4); axis off; text(0,0.5,'Histogram RGB -->');

figure(2); clf;
subplot(3,1,1); imhist(R); title('Histogram Merah');
subplot(3,1,2); imhist(G); title('Histogram Hijau');
subplot(3,1,3); imhist(B); title('Histogram Biru');

% 2. Meningkatkan Kecerahan
before = rgb2gray(imread('onepiece.jpg'));
after = before + 100;

figure(3); clf;
subplot(2,2,1); imshow(before); title('Before - Grayscale');
subplot(2,2,2); imshow(after); title('After - Cerah');
subplot(2,2,3); imhist(before); title('Histogram Before');
subplot(2,2,4); imhist(after); title('Histogram After');

% 3. Meregangkan Kontras
before = rgb2gray(imread('onepiece.jpg'));
after = uint8(2.5 * double(before));

figure(4); clf;
subplot(2,2,1); imshow(before); title('Before');
subplot(2,2,2); imshow(after); title('After - Kontras Ditingkatkan');
subplot(2,2,3); imhist(before); title('Histogram Before');
subplot(2,2,4); imhist(after); title('Histogram After');

% 4. Kombinasi Kecerahan & Kontras
before = rgb2gray(imread('onepiece.jpg'));
after = uint8(double(before) * 1.2 + 45);

figure(5); clf;
subplot(2,2,1); imshow(before); title('Before');
subplot(2,2,2); imshow(after); title('After - Cerah + Kontras');
subplot(2,2,3); imhist(before); title('Histogram Before');
subplot(2,2,4); imhist(after); title('Histogram After');

% 5. Membalik Citra
before = rgb2gray(imread('onepiece.jpg'));
after = 255 - before;

figure(6); clf;
subplot(2,2,1); imshow(before); title('Before - Grayscale');
subplot(2,2,2); imshow(after); title('After - Negatif');
subplot(2,2,3); imhist(before); title('Histogram Before');
subplot(2,2,4); imhist(after); title('Histogram After');

% 6. Pemetaan Nonlinier (Log)
before = rgb2gray(imread('onepiece.jpg'));
after_log = log(1 + double(before));
after = im2uint8(mat2gray(after_log));

figure(7); clf;
subplot(2,2,1); imshow(before); title('Before - Grayscale');
subplot(2,2,2); imshow(after); title('After - Log Transform');
subplot(2,2,3); imhist(before); title('Histogram Before');
subplot(2,2,4); imhist(after); title('Histogram After');

% 7. Pemotongan Aras Keabuan
function [Hasil] = potong(berkas, f1, f2)
    Img = imread(berkas);
    Img = rgb2gray(Img);
    [tinggi, lebar] = size(Img);
    Hasil = Img;
    for baris = 1 : tinggi
        for kolom = 1 : lebar
            if Hasil(baris, kolom) <= f1
                Hasil(baris, kolom) = 0;
            elseif Hasil(baris, kolom) >= f2
                Hasil(baris, kolom) = 255;
            end
        end
    end
end

before = rgb2gray(imread('onepiece.jpg'));
after = potong('onepiece.jpg', 30, 170);

figure(8); clf;
subplot(2,2,1); imshow(before); title('Before - Grayscale');
subplot(2,2,2); imshow(after); title('After - Potong Aras');
subplot(2,2,3); imhist(before); title('Histogram Before');
subplot(2,2,4); imhist(after); title('Histogram After');

% 8. Ekualisasi Histogram
img = rgb2gray(imread('onepiece.jpg'));
before = img;
[jum_baris, jum_kolom] = size(img);
L = 256;
Histog = zeros(L, 1);

for baris = 1 : jum_baris
    for kolom = 1 : jum_kolom
        nilai = img(baris, kolom);
        Histog(nilai + 1) = Histog(nilai + 1) + 1;
    end
end

alpha = (L - 1) / (jum_baris * jum_kolom);
C(1) = alpha * Histog(1);
for i = 2 : L
    C(i) = C(i - 1) + round(alpha * Histog(i));
end

after = img;
for baris = 1 : jum_baris
    for kolom = 1 : jum_kolom
        after(baris, kolom) = C(img(baris, kolom) + 1);
    end
end

after = uint8(after);

figure(9); clf;
subplot(2,2,1); imshow(before); title('Before - Grayscale');
subplot(2,2,2); imshow(after); title('After - Ekualisasi');
subplot(2,2,3); imhist(before); title('Histogram Before');
subplot(2,2,4); imhist(after); title('Histogram After');

% 9. Mengubah Background Jadi Putih
img = imread('onepiece.jpg');
lab = rgb2lab(img);
L = lab(:,:,1);

threshold = graythresh(mat2gray(L));
background_mask = mat2gray(L) > threshold;

output = img;
output(repmat(background_mask, [1,1,3])) = 255;

figure(10); clf;
subplot(2,2,1); imshow(img); title('Before - Asli');
subplot(2,2,2); imshow(output); title('After - BG Putih');
subplot(2,2,3); imhist(rgb2gray(img)); title('Histogram Before');
subplot(2,2,4); imhist(rgb2gray(output)); title('Histogram After');

