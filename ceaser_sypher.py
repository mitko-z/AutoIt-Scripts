import argparse
import sys

def caesar_cipher(text, shift, mode):
    """
    Encrypts or decrypts a text using the Caesar cipher method.
    Supports both Latin (26 letters) and Bulgarian Cyrillic (30 letters) alphabets.

    :param text: The text to be processed.
    :param shift: An integer for the character shift (the secret key).
    :param mode: 'encrypt' for encryption or 'decrypt' for decryption.
    :return: The processed text.
    """
    result = ""
    
    # Define alphabets explicitly
    LATIN_LOWER = "abcdefghijklmnopqrstuvwxyz"
    LATIN_UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    CYRILLIC_LOWER = "абвгдежзийклмнопрстуфхцчшщъьюя"
    CYRILLIC_UPPER = "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЬЮЯ"
    
    # Adjust shift for decryption
    if mode == 'decrypt':
        shift = -shift

    for char in text:
        if char in LATIN_LOWER:
            idx = LATIN_LOWER.index(char)
            result += LATIN_LOWER[(idx + shift) % 26]
        elif char in LATIN_UPPER:
            idx = LATIN_UPPER.index(char)
            result += LATIN_UPPER[(idx + shift) % 26]
        elif char in CYRILLIC_LOWER:
            idx = CYRILLIC_LOWER.index(char)
            result += CYRILLIC_LOWER[(idx + shift) % 30]  # Bulgarian Cyrillic has 30 letters
        elif char in CYRILLIC_UPPER:
            idx = CYRILLIC_UPPER.index(char)
            result += CYRILLIC_UPPER[(idx + shift) % 30]  # Bulgarian Cyrillic has 30 letters
        else:
            # If the character is a symbol, space, or number, keep it as is
            result += char
            
    return result

def main():
    """
    Main function to parse command-line arguments and get user input for the message.
    """
    # Create a parser for command-line arguments
    parser = argparse.ArgumentParser(description="Encrypt or decrypt multi-line text (supports Latin & Cyrillic).")
    
    # Add arguments for mode and key
    parser.add_argument("mode", choices=['encrypt', 'decrypt'], help="Choose 'encrypt' to encrypt or 'decrypt' to decrypt.")
    parser.add_argument("key", type=int, help="The secret integer key for the cipher.")
    
    # Parse the arguments from the command line
    args = parser.parse_args()
    
    # Prompt the user to enter their multi-line message
    print("Въведете вашето съобщение. Натиснете Ctrl+D (Linux/macOS) или Ctrl+Z и Enter (Windows), за да приключите.")
    
    # Read all lines from standard input until EOF (End-of-File)
    message = sys.stdin.read()
    
    # Call the cipher function with the provided arguments and the input message
    processed_message = caesar_cipher(message, args.key, args.mode)
    
    # Print the result
    print("\n" + ("-"*20))
    if args.mode == 'encrypt':
        print("Шифрирано съобщение:")
    else:
        print("Дешифрирано съобщение:")
    print(processed_message)

# Run the main function when the script is executed
if __name__ == "__main__":
    main()
