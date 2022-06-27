from PyQt6.QtWidgets import QWidget, QPushButton

class ClickerWindow(QWidget):

    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        #遥控器界面
        center = 100
        length = 150
        self.leftbtn = QPushButton('left', self)
        self.leftbtn.resize(length/3, length/3)
        self.leftbtn.move(center-length/2,center-length/6)

        self.rightbtn = QPushButton('right', self)
        self.rightbtn.resize(length/3, length/3)
        self.rightbtn.move(center+length/6,center-length/6)

        self.upbtn = QPushButton('up', self)
        self.upbtn.resize(length/3, length/3)
        self.upbtn.move(center-length/6, center-length/2)

        self.downbtn = QPushButton('down', self)
        self.downbtn.resize(length/3, length/3)
        self.downbtn.move(center-length/6, center+length/6)

        self.setGeometry(300, 300, 200, 200)
        self.setMinimumSize(200, 200)
        self.setWindowTitle('遥控器')
        # self.show()