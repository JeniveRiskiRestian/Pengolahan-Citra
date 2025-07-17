pkg load image;

% 1. Baca gambar
img = imread('menara.jpg');

% 2. Ukuran gambar
[rows, cols, ch] = size(img);

% 3. Titik acuan (tiga titik dari citra asli dan hasil)
pts1 = [50, 50; 200, 50; 50, 200];
pts2 = [70, 70; 220, 50; 100, 250];

% 4. Hitung transformasi affine
A = [pts1, ones(3,1)];
B = pts2;
T = A \ B;     % Least squares
T = T';        % Transpos agar sesuai
T = [T; 0 0 1]; % Tambahkan baris untuk matriks 3x3

% 5. Buat gambar output
output = zeros(rows, cols, ch, 'uint8');

% 6. Lakukan inverse transformasi per piksel
for y = 1:rows
  for x = 1:cols
    % Posisi output dalam vektor [x; y; 1]
    out_coords = [x; y; 1];
    in_coords = inv(T) * out_coords;  % Mapping ke koordinat asli
    x_in = in_coords(1);
    y_in = in_coords(2);

    % Jika dalam batas gambar asli
    if x_in >= 1 && x_in <= cols && y_in >= 1 && y_in <= rows
      % Ambil piksel dengan interpolasi nearest neighbor
      xi = round(x_in);
      yi = round(y_in);
      output(y, x, :) = img(yi, xi, :);
    end
  end
end

% 7. Tampilkan hasil
figure;
subplot(1,2,1); imshow(img); title('Citra Asli');
subplot(1,2,2); imshow(output); title('Transformasi Affine');

