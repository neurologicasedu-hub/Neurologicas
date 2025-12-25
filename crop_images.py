from PIL import Image
import os

def crop_and_save(source_path, dest_path, box):
    try:
        img = Image.open(source_path)
        cropped = img.crop(box)
        # Ensure directory exists
        os.makedirs(os.path.dirname(dest_path), exist_ok=True)
        cropped.save(dest_path)
        print(f"Saved {dest_path}")
    except Exception as e:
        print(f"Error processing {source_path}: {e}")

# Base path for artifacts (where uploaded images are)
artifact_path = r"C:\Users\plays\.gemini\antigravity\brain\68d97b46-aea1-4edc-84fd-ecedfaee3a2d"

# Source Images
img0 = os.path.join(artifact_path, "uploaded_image_0_1766282041734.png") # Executive/Cube
img1 = os.path.join(artifact_path, "uploaded_image_1_1766282041734.png") # Animals

# Destination Path (Project Assets)
dest_dir = r"c:\Users\plays\OneDrive\Documentos\MindCerto\neuro_calculator\assets\images"

# Coordinates (Estimated based on standard MoCA PDF layout in the screenshot)
# Verify dimensions of typical screenshot to guess percentages or fixed pixels.
# Assuming standard HD/FHD screenshot or PDF crop. 
# Let's verify image size first.
try:
    with Image.open(img0) as i:
        w, h = i.size
        print(f"Image 0 Size: {w}x{h}")
        
        # Trail Making (Left 1/3 roughly)
        # Approximate box: (0, 30, w*0.35, h) - Title is at top
        crop_and_save(img0, os.path.join(dest_dir, "Sequencia.png"), (0, 0, int(w*0.35), h))
        
        # Cube (Middle 1/3)
        # Approximate: (w*0.35, 0, w*0.65, h)
        crop_and_save(img0, os.path.join(dest_dir, "Cubo.png"), (int(w*0.35), 0, int(w*0.68), h))

    with Image.open(img1) as i:
        w, h = i.size
        print(f"Image 1 Size: {w}x{h}")
        # Animals (The whole strip essentially, maybe exclude title)
        # Approximate: (0, 30, w, h)
        crop_and_save(img1, os.path.join(dest_dir, "Animais.png"), (0, 30, w, h))

except Exception as e:
    print(f"Fatal error: {e}")
