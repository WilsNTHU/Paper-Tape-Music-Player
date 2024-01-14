from PIL import Image, ImageDraw
from draw_data import translate_to_binary

def generate_one_images(input_file):
    counter = 1
    with open(input_file, "r") as file:
        for decimal_stream in file.readlines():
            output_file = "out" + str(counter) + ".png"
            counter = counter + 1
            decimal_stream = decimal_stream.replace("\n", "")
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
            binary_stream = binary_result.rstrip("_")

            rectangle_width = 30

            # Draw data
            # image_width = len(binary_stream) * rectangle_width
            # image_height = 85 * 3
            image_width = 85 * 3
            image_height = len(binary_stream) * rectangle_width
            image = Image.new("RGB", (image_width, image_height), color="white")
            draw = ImageDraw.Draw(image)

            for i, bit in enumerate(binary_stream):
                color = "black" if bit == '0' else "white"
                # draw.rectangle([i * rectangle_width, 85, (i + 1) * rectangle_width, 85*2], fill=color)
                draw.rectangle([85, i * rectangle_width, 85*2, (i + 1) * rectangle_width], fill=color)


            # Draw equal
            bit = 1
            num_of_bits = len(binary_stream)
            for i in range(num_of_bits):
                color = "black" if bit == 0 else "white"
                # draw.rectangle([i * rectangle_width, 85*2, (i + 1) * rectangle_width, 85*3], fill=color)
                draw.rectangle([85*2, i * rectangle_width, 85*3, (i + 1) * rectangle_width], fill=color)
                bit = 1 - bit



            # Draw note 
            bit = 1
            for i in range(0, num_of_bits, 8):
                color = "black" if bit == 0 else "white"
                # draw.rectangle([i * rectangle_width, 0, (i + 8) * rectangle_width, 85], fill=color)
                draw.rectangle([0, i * rectangle_width, 85, (i + 8) * rectangle_width], fill=color)
                bit = 1 - bit

            # Save the image to a file
            image.save(output_file)