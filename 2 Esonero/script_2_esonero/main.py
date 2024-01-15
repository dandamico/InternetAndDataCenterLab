# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.
import re

def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press Ctrl+F8 to toggle the breakpoint.
    target = '192.168.10.50'
    port = '8080'
    if port is None:
        ip_address = target.split('.')
        if len(ip_address) != 4:
            return False

        for ip in ip_address:
            if not (ip.isnumeric()) or int(ip) < 0 or int(ip) > 255:
                return False
        return True

    else:
        ip_address = target.split('.')

        for elem in ip_address:
            port = elem.split(':')
            if len(port) == 2:
                ip_address.remove(elem)
                ip_address.append(port[0])
                ip_address.append(port[1])

        if len(ip_address) != 5:
            return False

        for ip in ip_address:
            if not (ip.isnumeric()) or int(ip) < 0 or int(ip) > 255:
                return False
        return True



# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print_hi('PyCharm')

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
