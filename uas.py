import os
import cv2
import tkinter as tk
from tkinter import filedialog, ttk, messagebox
from PIL import Image, ImageTk

# ====== FUNGSI CBIR ======
def load_all_images_from_subfolders(folder):
    paths = []
    for subfolder in os.listdir(folder):
        subpath = os.path.join(folder, subfolder)
        if os.path.isdir(subpath):
            for filename in os.listdir(subpath):
                if filename.lower().endswith(('.jpg', '.jpeg', '.png')):
                    paths.append(os.path.join(subpath, filename))
    return paths

def hitung_histogram(gambar_path):
    gambar = cv2.imread(gambar_path)
    if gambar is None:
        return None
    gambar = cv2.resize(gambar, (256, 256))
    hsv = cv2.cvtColor(gambar, cv2.COLOR_BGR2HSV)
    hist = cv2.calcHist([hsv], [0, 1], None, [50, 60], [0, 180, 0, 256])
    cv2.normalize(hist, hist)
    return hist

def cari_terdekat(query_path, semua_gambar, metode='correlation'):
    metode_dict = {
        'correlation': cv2.HISTCMP_CORREL,
        'chi-square': cv2.HISTCMP_CHISQR,
        'intersection': cv2.HISTCMP_INTERSECT,
        'bhattacharyya': cv2.HISTCMP_BHATTACHARYYA
    }

    query_hist = hitung_histogram(query_path)
    hasil = []
    for path in semua_gambar:
        if path == query_path:
            continue
        hist = hitung_histogram(path)
        if hist is not None:
            skor = cv2.compareHist(query_hist, hist, metode_dict[metode])
            hasil.append((path, skor))

    reverse = metode not in ['bhattacharyya', 'chi-square']
    hasil.sort(key=lambda x: x[1], reverse=reverse)
    return hasil

# ====== GUI FUNCTION ======
def tampilkan_gambar(canvas, path, ukuran=(200, 200)):
    img = Image.open(path)
    img = img.resize(ukuran)
    img = ImageTk.PhotoImage(img)
    canvas.image = img
    canvas.create_image(0, 0, anchor="nw", image=img)

def tampilkan_hasil(hasil_paths):
    for widget in hasil_frame.winfo_children():
        widget.destroy()
    max_cols = 4
    for i, (path, skor) in enumerate(hasil_paths):
        frame = tk.Frame(hasil_frame, bg="white", bd=1, relief="solid")
        frame.grid(row=i//max_cols, column=i%max_cols, padx=15, pady=15)
        img = Image.open(path)
        img = img.resize((120, 120))
        tk_img = ImageTk.PhotoImage(img)
        lbl_img = tk.Label(frame, image=tk_img, bg="white")
        lbl_img.image = tk_img
        lbl_img.pack()
        lbl_txt = tk.Label(frame, text=f"{os.path.basename(path)}\nSkor: {skor:.2f}", bg="white", font=("Segoe UI", 9))
        lbl_txt.pack()

def pilih_query():
    global query_path
    file_path = filedialog.askopenfilename(
        title="Pilih gambar query",
        filetypes=[("Image files", "*.jpg *.jpeg *.png")]
    )
    if file_path:
        query_path = file_path
        tampilkan_gambar(query_canvas, query_path, ukuran=(200, 200))

def jalankan_cbir():
    if not query_path:
        messagebox.showerror("Error", "Pilih gambar query terlebih dahulu!")
        return

    metode = metode_var.get()
    top_n = topn_var.get()

    try:
        top_n = int(top_n)
        if top_n < 1:
            raise ValueError
        elif top_n > 12:
            messagebox.showwarning("Peringatan", "Top-N dibatasi maksimal 12 gambar.")
            top_n = 12
    except:
        messagebox.showerror("Error", "Masukkan angka valid untuk Top-N.")
        return

    hasil = cari_terdekat(query_path, semua_gambar, metode)
    tampilkan_hasil(hasil[:top_n])

# ====== SETUP DATASET ======
query_path = None
dataset_folder = "C:/Users/ASUS/Downloads/bunga/flowers"

if not os.path.exists(dataset_folder):
    raise FileNotFoundError("❌ Folder dataset tidak ditemukan!")

semua_gambar = load_all_images_from_subfolders(dataset_folder)

# ====== GUI SETUP ======
root = tk.Tk()
root.title("🌺 CBIR - Pencarian Gambar")
root.geometry("1000x720")
root.configure(bg="#FCE4EC")

style = ttk.Style()
style.theme_use("clam")
style.configure("TButton", font=("Segoe UI", 10), padding=6)
style.configure("TCombobox", padding=4)

# Main Panel
main_panel = tk.Frame(root, bg="#FCE4EC")
main_panel.pack(side="left", fill="both", expand=True)

judul = tk.Label(main_panel, text="Hasil Pencarian Gambar", font=("Helvetica", 18, "bold"), bg="#FCE4EC", fg="#880E4F")
judul.pack(pady=20)

container_frame = tk.Frame(main_panel, bg="#FCE4EC")
container_frame.pack(fill="both", expand=True, padx=20, pady=10)

canvas_result = tk.Canvas(container_frame, bg="#FCE4EC")
scroll_y = tk.Scrollbar(container_frame, orient="vertical", command=canvas_result.yview)
hasil_frame = tk.Frame(canvas_result, bg="#FCE4EC")

hasil_frame.bind("<Configure>", lambda e: canvas_result.configure(scrollregion=canvas_result.bbox("all")))
canvas_result.create_window((0, 0), window=hasil_frame, anchor="nw")
canvas_result.configure(yscrollcommand=scroll_y.set)

canvas_result.pack(side="left", fill="both", expand=True)
scroll_y.pack(side="right", fill="y")

# Sidebar di kanan
sidebar = tk.Frame(root, width=250, bg="#F8BBD0")
sidebar.pack(side="right", fill="y")

title = tk.Label(sidebar, text="🔎 CBIR Tool", bg="#E91E63", fg="white", font=("Helvetica", 16, "bold"))
title.pack(pady=30)

btn_pilih = ttk.Button(sidebar, text="📁 Pilih Gambar", command=pilih_query)
btn_pilih.pack(pady=10, padx=20, fill="x")

query_canvas = tk.Canvas(sidebar, width=200, height=200, bg="white", bd=1, relief="ridge")
query_canvas.pack(pady=10)

lbl_metode = tk.Label(sidebar, text="Metode:", bg="#F8BBD0", fg="black", font=("Segoe UI", 10))
lbl_metode.pack(pady=(10, 0))
metode_var = tk.StringVar(value="correlation")
dropdown = ttk.Combobox(sidebar, textvariable=metode_var, values=[
    'correlation', 'chi-square', 'intersection', 'bhattacharyya'
], state="readonly")
dropdown.pack(pady=5, padx=20, fill="x")

lbl_topn = tk.Label(sidebar, text="Top-N Gambar:", bg="#F8BBD0", fg="black", font=("Segoe UI", 10))
lbl_topn.pack(pady=(10, 0))
topn_var = tk.StringVar(value="5")
entry_topn = ttk.Entry(sidebar, textvariable=topn_var)
entry_topn.pack(pady=5, padx=20, fill="x")

btn_cari = ttk.Button(sidebar, text="🔍 Cari Gambar Mirip", command=jalankan_cbir)
btn_cari.pack(pady=20, padx=20, fill="x")

root.mainloop()
