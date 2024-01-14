from top import generate_one_images

if __name__ == "__main__":
    in_file = "little_star.txt"
    generate_one_images(in_file)
    # translate_to_binary(in_file)


'''
if __name__ == "__main__":
    # Example binary stream
    # binary_stream = "0101010101010101010101010101010101010101010101010101010101010101"

    # Width and height of the image
    width = 800
    height = 250

    # Output file name
    # output_file = "binary_band_.png"
    # output_file = "binary_band_equal.png"
    output_file = "binary_band_equal_note.png"
    


    # Draw the binary band
    # draw_binary_band(binary_stream, width, height, output_file)
    # draw_binary_band_equal(100, width, height, output_file)
    draw_binary_note(20, height, output_file)
'''