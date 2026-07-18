"""
Script para gerar imagens placeholder das camisetas.
Requer: pip install Pillow
"""
import os

try:
    from PIL import Image, ImageDraw, ImageFont

    bandas = [
        (1, "Pink Floyd", "#1A1A2E", "#E94560"),
        (2, "AC/DC", "#0F3460", "#FFD700"),
        (3, "Metallica", "#16213E", "#C0C0C0"),
        (4, "Nirvana", "#1A1A2E", "#87CEEB"),
        (5, "Black Sabbath", "#0A0A0A", "#8B0000"),
        (6, "Guns N Roses", "#1A1A2E", "#FF4500"),
        (7, "Iron Maiden", "#0F3460", "#FF6347"),
        (8, "Led Zeppelin", "#16213E", "#DDA0DD"),
    ]

    os.makedirs("assets/images", exist_ok=True)

    for num, banda, bg, fg in bandas:
        img = Image.new("RGB", (400, 400), color=bg)
        draw = ImageDraw.Draw(img)

        # Desenha um retângulo decorativo
        draw.rectangle([20, 20, 380, 380], outline=fg, width=3)
        draw.rectangle([40, 40, 360, 360], outline=fg, width=1)

        # Ícone de camiseta (simplificado)
        draw.text((200, 140), "🎸", fill=fg, anchor="mm")
        draw.text((200, 220), banda, fill=fg, anchor="mm")
        draw.text((200, 260), f"Camiseta #{num:02d}", fill="#FFFFFF", anchor="mm")

        path = f"assets/images/camiseta_{num:02d}.png"
        img.save(path)
        print(f"Criada: {path}")

    print("Imagens geradas com sucesso!")

except ImportError:
    print("Pillow não instalado. Criando imagens PNG mínimas válidas...")

    import struct
    import zlib

    def make_png(width, height, r, g, b):
        """Cria um PNG RGB sólido mínimo sem dependências externas."""
        def chunk(name, data):
            c = zlib.crc32(name + data) & 0xFFFFFFFF
            return struct.pack('>I', len(data)) + name + data + struct.pack('>I', c)

        signature = b'\x89PNG\r\n\x1a\n'
        ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
        ihdr = chunk(b'IHDR', ihdr_data)

        raw_rows = b''
        for _ in range(height):
            row = b'\x00' + bytes([r, g, b] * width)
            raw_rows += row

        compressed = zlib.compress(raw_rows)
        idat = chunk(b'IDAT', compressed)
        iend = chunk(b'IEND', b'')

        return signature + ihdr + idat + iend

    cores = [
        (26, 26, 46),
        (15, 52, 96),
        (22, 33, 62),
        (26, 26, 46),
        (10, 10, 10),
        (26, 26, 46),
        (15, 52, 96),
        (22, 33, 62),
    ]

    os.makedirs("assets/images", exist_ok=True)

    for i, (r, g, b) in enumerate(cores, 1):
        path = f"assets/images/camiseta_{i:02d}.png"
        with open(path, "wb") as f:
            f.write(make_png(200, 200, r, g, b))
        print(f"Criada: {path}")

    print("Imagens placeholder criadas!")
