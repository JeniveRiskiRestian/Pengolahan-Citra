% Baca gambar
img = imread('lakilaki.png');
[rows, cols, ch] = size(img);
[x, y] = meshgrid(1:cols, 1:rows);

% Normalisasi
x_norm = (x - cols/2) / (cols/2);
y_norm = (y - rows/2) / (rows/2);
r = sqrt(x_norm.^2 + y_norm.^2);
theta = atan2(y_norm, x_norm);

% --- Fungsi umum ---
warp_image = @(xnew, ynew) uint8(cat(3, ...
    interp2(double(img(:,:,1)), xnew, ynew, 'linear', 0), ...
    interp2(double(img(:,:,2)), xnew, ynew, 'linear', 0), ...
    interp2(double(img(:,:,3)), xnew, ynew, 'linear', 0)));

% --- 1. Circular Swirl Grid ---
n_rings = 8; n_sectors = 12;
r_step = linspace(0, 1, n_rings+1);
theta_step = linspace(-pi, pi, n_sectors+1);
r_swirl = r;
theta_swirl = theta;
for i = 1:n_rings
    for j = 1:n_sectors
        mask = r >= r_step(i) & r < r_step(i+1) & ...
               theta >= theta_step(j) & theta < theta_step(j+1);
        swirl_angle = (mod(i+j, 2) - 0.5) * pi/3;
        theta_swirl(mask) = theta_swirl(mask) + swirl_angle;
    end
end
[x1, y1] = deal((r_swirl .* cos(theta_swirl)) * (cols/2) + cols/2, ...
                (r_swirl .* sin(theta_swirl)) * (rows/2) + rows/2);
img1 = warp_image(x1, y1);

% --- 2. Polar Unwrap & Wrap (Polar Art) ---
theta2 = mod(theta * 6, 2*pi);  % repeat pattern
r2 = r;
[x2, y2] = deal((r2 .* cos(theta2)) * (cols/2) + cols/2, ...
                (r2 .* sin(theta2)) * (rows/2) + rows/2);
img2 = warp_image(x2, y2);

% --- 3. Kaleidoscope Effect ---
theta3 = mod(abs(theta), pi/3);  % segi-enam simetri
[x3, y3] = deal((r .* cos(theta3)) * (cols/2) + cols/2, ...
                (r .* sin(theta3)) * (rows/2) + rows/2);
img3 = warp_image(x3, y3);

% --- 4. Ripple Effect (Gelombang tengah) ---
ripple_strength = 0.03;
freq = 30;
r4 = r + ripple_strength * sin(2 * pi * r * freq);
[x4, y4] = deal((r4 .* cos(theta)) * (cols/2) + cols/2, ...
                (r4 .* sin(theta)) * (rows/2) + rows/2);
img4 = warp_image(x4, y4);

% --- 5. Circular Zoom (Zoom tengah) ---
r5 = r.^0.6;
[x5, y5] = deal((r5 .* cos(theta)) * (cols/2) + cols/2, ...
                (r5 .* sin(theta)) * (rows/2) + rows/2);
img5 = warp_image(x5, y5);

% --- Tampilkan semua ---
figure('Name','Transformasi Geometri Artistik');
subplot(2,3,1); imshow(img); title('Gambar Asli');
subplot(2,3,2); imshow(img1); title('Swirl Grid');
subplot(2,3,3); imshow(img2); title('Polar Pattern');
subplot(2,3,4); imshow(img3); title('Kaleidoskop');
subplot(2,3,5); imshow(img4); title('Ripple Effect');
subplot(2,3,6); imshow(img5); title('Circular Zoom');

