import sys

def get_valid_power():
    while True:
        try:
            inp = input("Enter the laser power (0-255): ")
            inp = int(inp)
            if inp >= 0 and inp <= 255:
                return inp
        except:
            continue

def main():
    if len(sys.argv) < 2:
        print("Please provide a file name")
        return -1

    power = get_valid_power()
    
    try:
        with open(sys.argv[1], "r") as file:
            file_data = file.read()
        
        file_data = file_data.replace("E-", "\nM107 P0;")
        file_data = file_data.replace("E", f"\nM106 P0 S{power};")
        file_data = file_data.replace("QQQQ", "\nG28 X0 Y0 \nG91 \nM280 P0 S100 \nG1 Y220 F3600 \nM400 \nM280 P0 S0 \nM280 P0 S100 \nM280 P0 S90 \nG1 Y-150 E-200 F3000 \nG90")
        file_data+="\nM107 P0"
       
        with open(sys.argv[1], "w") as file:
            file.write(file_data)
        
    except:
        print(f"An error occured")
        return -1

if __name__ == "__main__":
    sys.exit(int(main() or 0))
