from PIL import Image, ImageDraw

# This file is for drawing the equal widths blocks for each note symbole (1 byte)

def draw_binary_note(num_of_symbols, output_file):
    
    # Create a new image with the specified width and height
    image_width = num_of_symbols * 8 * 10
    image_height = 250
    image = Image.new("RGB", (image_width, image_height), color="white")
    draw = ImageDraw.Draw(image)

    # Calculate the width of each rectangle
    rectangle_width = 10

    # Draw rectangles based on the binary stream
    bit = 1
    for i in range(0, num_of_symbols, 8):
        color = "black" if bit == 0 else "white"
        draw.rectangle([i * rectangle_width, 0, (i + 8) * rectangle_width, image_height], fill=color)
        bit = 1 - bit

    # Save the image to a file
    image.save(output_file)