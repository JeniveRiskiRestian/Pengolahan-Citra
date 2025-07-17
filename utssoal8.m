clc;
clear;

% === BACA GAMBAR ===
img = imread('jalanan.jpg');  % Ganti nama file jika perlu
img = im2double(img);
[r, c, ch] = size(img);

% === PARAMETER EFEK ===
amplitude = 10;      % untuk ripple
frequency = 0.05;
twirl_strength = 3;  % untuk twirl

% === EFEK RIPPLE ===
ripple_img = zeros(size(img));
for i = 1:r
    offset = round(amplitude * sin(2 * pi * frequency * i));
    for j = 1:c
        new_j = j + offset;
        if new_j >= 1 && new_j <= c
            ripple_img(i, j, :) = img(i, new_j, :);
        end
    end
end

% === EFEK TWIRL ===
twirl_img = zeros(size(img));
cx = c / 2;
cy = r / 2;
max_radius = sqrt(cx^2 + cy^2);

for y = 1:r
    for x = 1:c
        dx = x - cx;
        dy = y - cy;
        radius = sqrt(dx^2 + dy^2);

        if radius < max_radius
            angle = atan2(dy, dx) + twirl_strength * (max_radius - radius) / max_radius;
            new_x = round(cx + radius * cos(angle));
            new_y = round(cy + radius * sin(angle));

            if new_x >= 1 && new_x <= c && new_y >= 1 && new_y <= r
                twirl_img(y, x, :) = img(new_y, new_x, :);
            end
        end
    end
end

% === TAMPILKAN HASIL ===
figure('Name', 'Efek Ripple dan Twirl', 'NumberTitle', 'off');
subplot(1,3,1);
imshow(img);
title('Gambar Asli');

subplot(1,3,2);
imshow(ripple_img);
title('Efek Ripple');

subplot(1,3,3);
imshow(twirl_img);
title('Efek Twirl');

% === SIMPAN GAMBAR HASIL ===
imwrite(ripple_img, 'hasil_ripple.jpg');
imwrite(twirl_img, 'hasil_twirl.jpg');

