"""
App.py is a test app for cicd
"""

version = "0.1"

# sum returns the sum of the two input parameters
def sum(num1,num2):
    return int(num1) + int(num2)

def main():
    print("Hello, you're running version %s of the application" % version)
    print("2 + 2 = %d" % sum(2,2))


if __name__ == '__main__':
    main()

