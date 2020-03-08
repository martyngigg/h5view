
class NotCallable():
    pass

def main(arg1,arg2):
    NotCallable()()
    return None

if __name__ == '__main__':
    main()
