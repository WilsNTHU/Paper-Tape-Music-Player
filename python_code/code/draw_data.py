from PIL import Image, ImageDraw

# This file is for drawing the translated data
# each notes occupy 1 bytes, value range from 0 to 63 in decimal notation
# which is at most 2 digits

def translate_to_binary(input_file):
    with open(input_file, "r") as file:
        decimal_stream = file.read().replace("\n", "")
        binary_result = ""

        i = 0
        while i < len(decimal_stream):
            # Extract two and one decimal digits at a time
            if i + 1 < len(decimal_stream):
                dec_pair = decimal_stream[i:i + 2]
                dec_pair_2 = decimal_stream[i + 2]
            else:
                dec_pair = decimal_stream[i]
                dec_pair_2 = ""

            # Convert the decimal digits to binary
            binary_pair = bin(int(dec_pair))[2:].zfill(6)
            binary_pair_2 = bin(int(dec_pair_2))[2:].zfill(2)

            # Append the binary pairs to the result
            binary_result += binary_pair
            binary_result += binary_pair_2

            # Move to the next pair
            i += 4

    # Remove the trailing underscore
    binary_result = binary_result.rstrip("_")

    return binary_result

def translated_to_binary_stream(input_file):
    file = open(input_file, "r")
    binary_stream = file.read()
    binary_stream = binary_stream.replace("\n", "")
    binary_result = ""
    
    # Iterate over every two characters in the input hexadecimal string
    for i in range(0, len(binary_stream), 4): # e.g. 331_391_311_
        # Extract two characters at a time
        dec_pair = binary_stream[i:i+2]
        dec_pair_2 = binary_stream[i+2]
        
        # Convert the hexadecimal pair to binary and remove the '0b' prefix
        binary_pair = bin(int(dec_pair, 10))[2:]
        binary_pair_2 = bin(int(dec_pair_2, 10))[2:]
        
        # Ensure that the binary representation is 8 bits by padding with zeros if needed
        binary_pair = binary_pair.zfill(6)
        binary_pair_2 = binary_pair.zfill(2)
        
        # Append the binary pair to the result
        binary_result += binary_pair
        binary_result += binary_pair_2
    
    return binary_result

def draw_binary_data(binary_stream, output_file):
    # Read the translated binary stream
    image_width = len(binary_stream) * 10
    image_height = 250

    # Create a new image with the specified width and height
    image = Image.new("RGB", (image_width, image_height), color="white")
    draw = ImageDraw.Draw(image)

    # Calculate the width of each rectangle
    rectangle_width = 10

    # Draw rectangles based on the binary stream
    for i, bit in enumerate(binary_stream):
        color = "black" if bit == '0' else "white"
        draw.rectangle([i * rectangle_width, 0, (i + 1) * rectangle_width, image_height], fill=color)

    # Save the image to a file
    image.save(output_file)